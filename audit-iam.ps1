param(
    [string]$ResourceGroup = "rg-iam-security-lab",
    [string]$OutputPath = "./iam-audit.csv"
)

$labScope = az group show --name $ResourceGroup --query id --output tsv
if ($LASTEXITCODE -ne 0 -or -not $labScope) {
    throw "Could not identify resource group."
}

$assignmentJson = az role assignment list --scope $labScope --include-inherited --output json
if ($LASTEXITCODE -ne 0) {
    throw "Could not retrieve role assignments."
}

$assignments = $assignmentJson | ConvertFrom-Json
$reviewRoles = @(
    "Owner",
    "Contributor",
    "User Access Administrator",
    "Role Based Access Control Administrator"
)

$audit = @(
    foreach ($assignment in $assignments) {
        [PSCustomObject]@{
            Identity = $assignment.principalName
            Type = $assignment.principalType
            Role = $assignment.roleDefinitionName
            Scope = $assignment.scope
            AccessPath = if ($assignment.scope -ieq $labScope) {
                "At resource group"
            } else {
                "Inherited from parent"
            }
            Review = if ($assignment.roleDefinitionName -in $reviewRoles) {
                "Review privileged access"
            } else {
                "Check against business need"
            }
        }
    }
)

if ($audit.Count -eq 0) {
    Write-Warning "No assignments returned; verify scope and permissions."
} else {
    $audit | Export-Csv -Path $OutputPath -NoTypeInformation
    $audit | Format-List
    Write-Host "Audit saved to $OutputPath"
}

# Lists assignments, not a complete effective-permissions assessment.
# Does not expand group membership, inspect custom-role permissions,
# or evaluate deny assignments, conditions, or PIM eligibility.

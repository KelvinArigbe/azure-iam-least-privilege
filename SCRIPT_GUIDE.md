# Understanding audit-iam.ps1

This guide explains the tested lab script; it is not a claim that the author wrote it unaided.

| Construct | Purpose |
|---|---|
| param | Lets the caller choose a resource group and output file |
| $labScope = az group show | Saves the resource group's full ID in a variable |
| $LASTEXITCODE | Checks whether the preceding Azure CLI command failed |
| az role assignment list | Reads role assignments at the requested scope plus inherited ones |
| ConvertFrom-Json | Makes the returned JSON accessible as PowerShell objects |
| $reviewRoles | Holds a list of privileged role names for review |
| foreach | Processes each assignment |
| [PSCustomObject] | Creates a structured report row |
| -ieq | Compares scope strings without case sensitivity |
| -in | Checks whether a role name is in the review list |
| @() | Collects the resulting rows in an array |
| Export-Csv | Writes a local report; can overwrite an existing file |
| Format-List | Displays each row in the terminal |

## Review before running

Read every command and its arguments. Confirm the active subscription and your read permissions. The two Azure CLI operations in this file are group show and role assignment list; neither changes Azure access. Export-Csv writes a file, which can contain account names and scope IDs. Keep real output out of public commits.

The wrapper used to save the script in Cloud Shell was a single-quoted here-string followed by Set-Content. Set-Content wrote the script file; it is not part of the script's Azure auditing logic.

A successful run proves that the script produced the observed inventory for that session. It does not prove complete effective-access coverage or absence of every security issue. Compare the results with IAM in the portal. Privileged role names are review candidates, not automatically findings.

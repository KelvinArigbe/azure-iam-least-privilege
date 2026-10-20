# Azure IAM Access Review and Least-Privilege Remediation

**Author:** Kelvin Arigbe  
**Completed lab work:** 20 October 2026  
**Context:** Project 4 - IAM and least privilege; personal Azure lab, not a production engagement.  
**Status:** Configuration and testing complete; cleanup pending confirmation.

## Problem and outcome

An analyst initially received Contributor even though the job required read-only access. I verified tag-write access, replaced the role with Reader, and retested. I then moved baseline access to a security group, introduced an overlapping Contributor assignment to investigate additive permissions, and removed it to restore the restriction.

For an updated requirement to maintain tags, I created Lab Tag Operator with three explicit actions and assigned it at the lab resource-group scope. Group Reader supplied general read visibility. Tag updates succeeded while portal role-assignment controls remained unavailable.

## Scope and intended access

- Empty lab resource group: `rg-iam-security-lab`.
- Test identity: `lab-analyst`; security group: `sg-lab-readers`.
- Administration: existing Owner inherited from subscription; retained as expected lab administration.
- Final analyst access: Reader through the group plus a directly assigned custom tag role.
- No paid workloads were deployed for these exercises. This is not a verified billing statement or a guarantee about unrelated account charges.

## Validated results

| Configuration | View group | Tag update | Evidence basis |
|---|---|---|---|
| Direct Contributor | Allowed | Succeeded | Screenshots 01-02; Activity log 05 |
| Direct Reader | Allowed | Blocked | Screenshots 03-04; participant confirmation |
| Group Reader only | Allowed | Blocked | Screenshot 09; removal and viewing confirmed in session |
| Group Reader + direct Contributor | Allowed | Succeeded | Screenshots 10-11 prove roles; write success confirmed in session |
| Group Reader after Contributor removal | Allowed | Blocked | Screenshot 12; participant confirmation |
| Group Reader + Lab Tag Operator | Allowed | Succeeded | Screenshots 13-15; participant confirmation |

Role-assignment controls were disabled in the final analyst session (16). No role-assignment API request was submitted as a negative test.

## Final assignment inventory

| Identity | Role | Scope | Review decision |
|---|---|---|---|
| Admin | Owner | Subscription; inherited by lab group | Expected lab administration; review periodically |
| sg-lab-readers | Reader | Lab resource group | Baseline read visibility |
| Lab Analyst | Lab Tag Operator | Lab resource group | Tag-maintenance requirement; explicit exception to group-based baseline |

Direct assignment of the custom role was used to keep the experiment isolated. For multiple tag operators, a separate assigned security group would reduce individual assignments; this improvement was not implemented in this lab.

## Implementation sequence

1. Create a resource group and test user; give the user Contributor at the lab group only.
2. Sign in as the test user and save a tag; capture the role and write evidence.
3. Create Reader and remove Contributor. Actual baseline event order was Reader created first, then Contributor deleted.
4. Refresh the analyst session and confirm viewing succeeds while tag updates fail.
5. Create sg-lab-readers with assigned membership and add the analyst.
6. Assign Reader to the group, remove direct Reader, refresh and repeat the read/write tests.
7. Add direct Contributor alongside group Reader, observe overlapping assignments and confirm tag writing works. Remove Contributor and verify writes are blocked again.
8. Create and assign Lab Tag Operator with the three actions below; keep group Reader. Verify tag updates and inspect disabled role-assignment controls.
9. Use Cloud Shell PowerShell and Azure CLI to inventory assignments and flag four common privileged role names for review.

## Custom-role design

| Action | Reason |
|---|---|
| Microsoft.Resources/subscriptions/resourceGroups/read | View resource-group information |
| Microsoft.Resources/tags/read | Read tags |
| Microsoft.Resources/tags/write | Update tags |

No wildcard actions, role-assignment writes, data actions, resource deployment writes or resource-group deletion actions are included. Tags/write can replace or remove existing tags as part of an update; this role does not restrict individual tag names or values. Resource-group assignment can apply to tag operations on descendant resources if later added; only the resource-group tag operation was tested here.

`policies/lab-tag-operator.portal.json` is a reconstructed publication template matching the permissions visible in screenshot 13, using the Azure portal JSON shape. Replace `<SUBSCRIPTION_ID>` locally before use. It is not the downloaded account-specific export and is not a ready-to-run `az role definition create` input file.

## Audit script

The `scripts/audit-iam.ps1` script is reconstructed from the version the participant ran successfully in Cloud Shell during the lab. No CSV output is committed.

```powershell
# In an authenticated PowerShell session with Azure CLI available:
./scripts/audit-iam.ps1 -ResourceGroup rg-iam-security-lab -OutputPath ./iam-audit.csv
```

The script reads the active subscription's lab scope, lists assignments there plus inherited assignments, labels the access path, flags Owner / Contributor / User Access Administrator / Role Based Access Control Administrator, and writes a local CSV. It makes no Azure access changes. It does overwrite the selected local output file if it already exists.

**Review flag does not mean vulnerability.** Owner for the lab administrator is expected. A role not on the list is not automatically safe. Name matching is a simple review aid; production checks should use stable role-definition IDs and inspect permissions and business context.

Limitations: it does not expand group membership, evaluate custom-role actions, deny assignments, conditions or PIM eligibility; it is not a complete effective-permissions assessment. At this lab scope it does not recursively inventory every descendant resource assignment. It relies on the selected subscription and the caller's visibility. Changes in access may require propagation and a refreshed sign-in.

## Audit trail

20 October 2026, West Africa Time (UTC+1). Exact times below were transcribed during the lab; screenshot 05 shows the operation rows but truncated times. Role mappings were checked by the participant in event details.

| Time | Operation | Confirmed interpretation |
|---|---|---|
| 08:00:38 | Update resource group | Initial resource-group event; not labelled as creation |
| 08:11:25 | Create role assignment | Contributor assigned |
| 08:35:46 | Write tags | Analyst write succeeded |
| 08:41:59 | Create role assignment | Reader assigned |
| 08:42:47 | Delete role assignment | Contributor removed |

## Evidence

All 15 supplied screenshots have publication copies in `evidence/`. See [EVIDENCE_REVIEW.md](EVIDENCE_REVIEW.md) for individual captions, redactions and evidence limitations. Numeric gaps are retained rather than inventing missing screenshots. File 11 is a second overlapping-role view and has been renamed to reflect its content.

## Cleanup checklist - not yet confirmed

After verifying local copies of the evidence:

- [ ] Remove the lab user's Lab Tag Operator assignment.
- [ ] Remove the lab group's Reader assignment.
- [ ] Delete the now-unassigned Lab Tag Operator custom role definition while its scope is still present.
- [ ] Delete the lab security group and test user using the appropriate Entra administrator account.
- [ ] Delete the empty lab resource group.
- [ ] Confirm the lab items are gone; retain existing admin access.

Do not remove your own subscription Owner assignment. Azure resource roles and Entra directory administration are separate permissions.

## Repository contents

- `README.md`: scenario, decisions, results, limitations and cleanup.
- `evidence/`: publication copies only.
- `scripts/audit-iam.ps1`: lab inventory and review script.
- `policies/lab-tag-operator.portal.json`: placeholder-only custom-role template.
- `EVIDENCE_REVIEW.md`: evidence and privacy review.
- `SCRIPT_GUIDE.md`: short explanation of the tested script.
- `LINKEDIN_POST.md`: draft for manual publishing.

AI assistance was used for scripting and documentation. I performed the portal configuration and validation in my lab. The generated audit script was executed successfully in the lab; it remains a limited review aid.

## References

- [Azure RBAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)
- [Azure custom roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Tags and access requirements](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)
- [List role assignments with Azure CLI](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-list-cli)

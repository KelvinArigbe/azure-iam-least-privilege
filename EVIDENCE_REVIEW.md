# Evidence review and publication privacy

Reviewed: 20 October 2026. Originals were left unchanged. Only publication copies are included.

Solid pixel masks cover selected identity fields; portal account headers were cropped. The PNGs were re-encoded without original metadata. Review combined visual inspection and OCR checks for known account strings and GUIDs. No passwords, keys or tokens were observed in the supplied screenshots; this is a review of these images, not the entire account. Azure resource and object IDs are identifiers, not authentication secrets; they were removed to reduce unnecessary disclosure.

Generic lab labels are retained: lab-analyst, sg-lab-readers, rg-iam-security-lab, and Lab Tag Operator. The report intentionally credits Kelvin Arigbe as author.

No CSV exports, raw role-definition exports, original screenshots or real subscription IDs are included.

| Publication image | What it supports | Privacy treatment |
|---|---|---|
| `01-contributor-before.png` | Direct Contributor on Lab Analyst; inherited administrative Owner. | Admin display name and object IDs masked. |
| `02-write-access-before.png` | Stored AccessTest tag with BeforeRemediation value. | Portal account header cropped. |
| `03-reader-after.png` | Lab Analyst assigned Reader after baseline remediation. | Account header cropped; admin name and object IDs masked. |
| `04-write-denied-after.png` | AuthorizationFailed banner during Reader tag-change attempt. | No account identifiers visible in supplied crop. |
| `05-activity-log.png` | Successful write-tags and role-assignment events. Role names are not visible in rows. | Initiating email addresses masked. |
| `06-group-membership.png` | Lab Analyst appears as a member of sg-lab-readers. | Portal account header cropped. |
| `07-group-reader-assignment.png` | Transitional state: direct Reader and group Reader both exist. | Admin display name and object IDs masked. |
| `09-group-access-write-blocked.png` | AuthorizationFailed banner during group-access stage; role removal confirmed in session. | No account identifiers visible in supplied crop. |
| `10-overlapping-roles.png` | Direct Contributor plus Reader through sg-lab-readers. | No account identifiers visible in supplied crop. |
| `11-overlap-role-confirmation.png` | Second view of overlapping roles; NOT a successful tag-write screenshot. | Portal account header cropped; filename corrected. |
| `12-overlap-removed-write-blocked.png` | AuthorizationFailed after removal of direct Contributor, as confirmed in session. | Portal account header cropped. |
| `13-custom-role-permissions.png` | Explicit resource-group read and tag read/write permissions. | Portal account header cropped; subscription scope line masked. |
| `14-custom-role-assignment.png` | Lab Tag Operator directly assigned alongside group Reader. | Portal account header cropped. |
| `15-custom-role-tag-update.png` | Stored CustomRoleTest tag, value BeforeRemediation, with No changes displayed. | Portal account header cropped. |
| `16-role-assignment-unavailable.png` | Add role assignment is disabled in Lab Analyst portal session. | Portal account header cropped. |

## Evidence limitations

- File 11 originally claimed a write succeeded but depicts role assignments. It is renamed; write success during overlap is a participant-confirmed result, not independently proved by that image.
- File 07 shows the temporary direct-plus-group Reader state. It does not prove that direct Reader was removed.
- The tag screens show tag-name changes in later stages; the report therefore says tag updates rather than claiming a specific value change.
- Disabled role-assignment controls are UI evidence, not a submitted API denial.
- Screenshot 08 and a CLI audit screenshot were not supplied. Terminal results and successful script execution were confirmed in the session.
- Cleanup has not been confirmed.

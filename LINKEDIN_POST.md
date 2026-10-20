I completed an Azure IAM lab focused on a practical question: does a user's access actually match their responsibilities?

I started with an analyst who had Contributor access but only needed to view resources. After testing a tag write, I replaced Contributor with Reader and verified that viewing still worked while writes were blocked.

I then moved baseline access to a security group and tested overlapping permissions. Reader through a group did not cancel a direct Contributor assignment. Removing that assignment restored the restriction.

For a new tag-maintenance requirement, I created a custom role with explicit resource-group read and tag read/write permissions. Tag updates worked, while role-assignment controls remained unavailable in the portal.

I also used an AI-assisted PowerShell/Azure CLI script to inventory assignments and flag common privileged roles for review, checking its output against the portal.

My main takeaway: review every access path, test both allowed and blocked actions, and separate privileged access that needs review from access that is actually inappropriate.

The attached report includes redacted evidence, results and limitations. This was a personal lab, not a production audit.

#Azure #CloudSecurity #IAM #PowerShell #Cybersecurity

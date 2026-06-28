# Azure platform

Terraform + pipeline yaml for an Azure stack. One repo, separate folders — easier to review than a monolith.

- [application/](application/) — App Service, Functions for async jobs
- [integration/](integration/) — APIM, Service Bus
- [data/](data/) — SQL with geo-rep, blob for images
- [infrastructure/](infrastructure/) — modules, dev/test/prod tfvars
- [cicd/](cicd/) — Azure DevOps pipeline, promote through envs
- [observability/](observability/) — Log Analytics, App Insights, KQL
- [security/](security/) — private endpoints, WAF, Key Vault, policy, RBAC

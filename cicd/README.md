# CI/CD

Azure DevOps YAML pipeline — validate Terraform, deploy infra, build the app, run tests, then promote through dev → test → prod. Prod needs an approval.

## What's here

- Pipeline yaml at `cicd/azure-pipelines.yml` (point ADO at this path)
- Reusable template for terraform fmt/validate
- Deploys from `infrastructure/terraform` using env tfvars

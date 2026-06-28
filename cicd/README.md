# CI/CD

Azure DevOps pipeline — fmt/validate terraform, deploy infra, build app, tests, promote dev → test → prod. Prod needs manual approval.

`azure-pipelines.yml` is the entry point. Template for terraform validate. Deploys from `infrastructure/terraform` with env tfvars.

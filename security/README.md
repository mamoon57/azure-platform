# Security

Private networking so services aren't on the public internet. WAF on the edge, secrets in Key Vault, Defender and Policy for baseline compliance. RBAC scoped as tight as possible.

## What's here

- VNet with private endpoints for Key Vault and SQL
- WAF policy (hook up to App Gateway or Front Door in the app stack)
- Azure Policy definition for required tags
- Custom role example with least privilege

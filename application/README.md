# Application

Web app sits on App Service. Heavier or async stuff runs in Functions — order processing, outbound notifications, that kind of thing.

## What's here

- Terraform for the app service plan, web app, and function app
- Basic functions host.json to get started locally

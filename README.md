# Radix example: Deploy-only

## Required changes to Radix

There need to be a service principle or serviceaccount with the following (cluster)roles in cluster: `radix-platform-user`,`radix-app-admin`, `radix-platform-user-rr-radix-example-arm-template`, `radix-app-adm-api`

## Choices

The service principle creating azure resources does not have access to create new resource groups. This has to be done manually upfront. A different solution is to grant the service principle contributer on subscription level. 

Another simpler way to do do both ARM template and build/deploy to Radix, is to setup a github webhook in Radix, and have that trigger build/deploy there. The github action then only needs to contain the ARM template generation and maybe the setsecret if you want to automate that.

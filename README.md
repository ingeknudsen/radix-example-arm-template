# radix-example-arm-template

## Required changes to Radix

There need to be a service principle or serviceaccount with the following (cluster)roles in cluster: `radix-platform-user`,`radix-app-admin`, `radix-platform-user-rr-radix-example-arm-template`, `radix-app-adm-api`

## Improvements

A Radix CLI would make this simpler, as the curl command that goes through the API is hard to get correct. 

First time you set secrets in Radix, it might fail, as the application is not deployed to that environment yet. Second time it works

The mapping between branch and environment is somewhat complex to manage, not sure how this can be improved

## Choices

The service principle creating azure resources does not have access to create new resource groups. This has to be done manually upfront. A different solution is to grant the service principle contributer on subscription level. 

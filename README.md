# Radix example: Deploy-only

This is the repository that shows how to set up your application to be built outside of Radix, and deployed to Radix through the use of the Radix API. To see more documentation on this please refer to the [public documentation](https://www.radix.equinor.com/guides/deploy-only/)

The application make use of a storage account, set up by the use of arm templates. The github actions workflow will pull the secrets for this storage account, and use the Radix API to set the secrets to the application, once deployed to Radix.

## For Radix developers

- Have set up an [app registration](https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Overview/appId/ecbb2c1e-daf1-4ae2-8752-5d9a1e6514ed/isMSAApp/)
- Have set up two resource groups. One for [qa](https://portal.azure.com/#@StatoilSRM.onmicrosoft.com/resource/subscriptions/16ede44b-1f74-40a5-b428-46cca9a5741b/resourceGroups/deploy-only-arm-template-qa/overview) and one for [prod](https://portal.azure.com/#@StatoilSRM.onmicrosoft.com/resource/subscriptions/16ede44b-1f74-40a5-b428-46cca9a5741b/resourceGroups/deploy-only-arm-template-prod/overview)
- Have added radix-example-arm-template service principal as `Contributor` to these resource groups
- Deployed to resource group `az deployment group create --name deploy-only --resource-group deploy-only-arm-template-<qa|prod> --template-file ./arm-templates/azuredeploy.json`

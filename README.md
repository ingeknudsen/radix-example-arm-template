# Radix example: Deploy-only.

This is the repository that shows how to set up your application to be built outside of Radix, and deployed to Radix through the use of the Radix API. To see more documentation on this please refer to the [public documentation](https://www.radix.equinor.com/guides/deploy-only/)

The application make use of a storage account, set up by the use of arm templates. The github actions workflow will pull the secrets for this storage account, and use the Radix API to set the secrets to the application, once deployed to Radix.

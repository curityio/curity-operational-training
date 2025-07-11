# Deploy to Real Environments

These resources accompany the lessons from the [Deployments and Upgrades](https://curity.io/training/deployments-and-upgrades) course.\
An example that deals with additional infrastructure and permissions from cloud environments.

## Azure Container Apps Deployment

This particular deployment uses Azure Container Apps, with Azure SQL for storage.\
First, create an Azure account like a free trial for developers.\
Install the Azure CLI, run `az login` and then run scripts in a numeric sequence:

- ./1-create-environment.sh
- ./2-create-registry.sh
- ./3-build-images.sh
- ./4-deploy-database.sh
- ./5-deploy-databasejob.sh
- ./6-deploy-idsvr.sh

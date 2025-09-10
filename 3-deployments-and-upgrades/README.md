# Deploy to Real Environments

These resources accompany the lessons from the [Deployments and Upgrades](https://curity.io/training/deployments-and-upgrades) course.

## Deployment Approach

The deployment to a real cloud platform should perform the following steps.\
You can use a Kubernetes cluster for the most complete deployment control.

- Create a cluster.
- Build a custom image of the Curity Identity Server that contains shared resources like configuration.
- Deploy multiple replicas of the image to enable OAuth endpoints with high availability.
- Expose OAuth endpoints at internet HTTPS URLs.
- Create durable storage for the Curity Identity Server.
- Integrate with managed services and use infrastructure security permissions.

## Run an Azure Container Apps Deployment

The example deployment demonstrates that other options are also possible.\
It shows how to deploy the Curity Identity Server as Azure Container Apps, with Azure SQL for storage.

First, create an Azure account, like a free trial for developers.\
Install the Azure CLI, run `az login` and then run scripts in a numeric sequence:

- ./1-create-environment.sh
- ./2-create-registry.sh
- ./3-build-images.sh
- ./4-deploy-database.sh
- ./5-deploy-databasejob.sh
- ./6-deploy-idsvr.sh

## Use the Deployed System

On completion, get working internet HTTPS URLs and use them to connect to admin and runtime endpoints:

```bash
ADMIN_FQDN=$(az containerapp show \
    --name idsvr-admin \
    --resource-group "curity-rg" \
    --query properties.configuration.ingress.fqdn --output tsv)
echo "https://$ADMIN_FQDN/admin"

RUNTIME_FQDN=$(az containerapp show \
    --name idsvr-runtime \
    --resource-group "curity-rg" \
    --query properties.configuration.ingress.fqdn --output tsv)
echo "https://$RUNTIME_FQDN/~/.well-known/openid-configuration"
```

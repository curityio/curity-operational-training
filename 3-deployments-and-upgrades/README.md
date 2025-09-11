# Deploy to Real Environments

These resources accompany the lessons from the [Deployments and Upgrades](https://curity.io/training/deployments-and-upgrades) course.\
The scripts run a demo level deployment to the Azure cloud.

## Deployment Approach

The deployment to a real cloud platform should perform the following steps.\
You can use a Kubernetes cluster for the most complete deployment control.

- Create a cluster.
- Build a custom image of the Curity Identity Server that contains shared resources like configuration.
- Deploy multiple replicas of the image to enable OAuth endpoints with high availability.
- Expose OAuth endpoints at internet HTTPS URLs with precreated custom domain names.
- Create durable storage for the Curity Identity Server.
- Integrate with managed services and use infrastructure security permissions.

## Run an Azure Container Apps Deployment

The example deployment demonstrates that other options are also possible.\
It shows how to deploy the Curity Identity Server as Azure Container Apps, with Azure SQL for storage.

First, create an Azure account, like a free trial for developers.\
Install the Azure CLI, run `az login` and then run scripts one at a time in the following sequence.\
Verify that each script completes successfully before running the next one.

```bash
./1-create-environment.sh
./2-create-registry.sh
./3-build-images.sh
./4-deploy-database.sh
./5-deploy-databasejob.sh
./6-deploy-idsvr.sh
```

## Post Deployment Configuration

The example deployment uses domain names that Azure generates.\
Run a patch to update to the dynamically generated URLs from Azure.\
In the event of failure, apply settings to match the patch.xml file manually in the Admin UI.

```bash
./postdeployment/patch.sh
```

## Troubleshoot

Get container IDs:

```bash
az containerapp replica list \
  --name idsvr-admin \
  --resource-group curity-rg \
  --query '[].name' \
  --output tsv

az containerapp replica list \
  --name idsvr-runtime \
  --resource-group curity-rg \
  --query '[].name' \
  --output tsv
```

Then tail logs using a container ID:

```bash
az containerapp logs show \
  --name idsvr-admin \
  --resource-group curity-rg \
  --replica MY_ADMIN_CONTAINER_ID \
  --follow

az containerapp logs show \
  --name idsvr-admin \
  --resource-group curity-rg \
  --replica MY_RUNTIME_CONTAINER_ID \
  --follow
```

## Test OAuth Flows

Once you are comfortable with the deployment you can test using the internet cluster.\
See the [Testing Instructions](TESTING.md) to run some user authentication and token issuance flows.

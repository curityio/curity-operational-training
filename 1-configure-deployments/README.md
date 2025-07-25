# Configure Deployments

These resources accompany the lessons from the [Configure Deployments](https://curity.io/training/configure-deployments) course.\
They demonstrate how you should enable deployment pipelines and evolve your configuration.

- The initial deployment and generation of default configuration.
- Redeployments with the latest configuration and control over external URLs.
- Run a cluster with high availability OAuth endpoints.
- Integrate refinements like split configuration.
- Create protected stage-specific secrets on every deploymeent.
- Use service roles for greater control over OAuth endpoints.

Each deployment uses a local Docker Compose environment so that you get fast feedback.\
For each lesson, copy in a `license.json` file and run `./go.sh` to perform the deployment.

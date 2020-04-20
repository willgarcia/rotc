# Kubectl

Access a remote Kubernetes cluster

## kubectl installation

   ```bash
   # Windows
   choco upgrade gcloudsdk

   # MacOS
   brew cask install google-cloud-sdk
   ```

## Authenticate to GCP

* Log in to GCP with `gcloud auth login`. You'll need to log in with a Google account linked to the email address that these instructions were sent to.
* Configure your local Docker installation to use GCP's authentication mechanism when needed: `gcloud auth configure-docker`

## Access the Kubernetes cluster on GCP (GKE)

```bash
gcloud container clusters get-credentials k8s-cluster --region australia-southeast1 --project rotc-22-04
```

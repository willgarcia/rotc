# Instructor setup

This file contains instructions for instructors to create all of the resources used during the workshop.

# AWS
* Run `./batect -f aws.yml login_aws` to set up the AWS credentials - this will overwrite your local AWS config

* Run `./batect -f aws.yml setup-terraform` to get your terraform environment ready

* Run `./batect -f aws.yml apply-terraform` to set up the AWS environment for a service mesh

#### Install Istio
* Run `./batect -f aws.yml install-istio` to install Istio and deploy the Bookinfo Application

* Run `./batect -f aws.yml shell` to open a shell inside the cluster

* Run `./batect -f aws.yml destroy-terraform` to destroy the environment

# Azure
## Prequisites

* Create a storage account in Azure to hold the TF state file
* Set up an environment variable AZURE_TF_STORAGE_ACCOUNT with a unique name like '<yourname>stgterra1'
  * (Optional) Install direnv, and setup a .envrc file to hold the env var.
      * `brew install direnv`
      * `EXPORT AZURE_TF_STORAGE_ACCOUNT=<yourname>stgterra`

## Steps
* Run `./batect -f azure.yml login_azure` to set up the AWS credentials - this will overwrite your local AZure config

* Run `./batect -f azure.yml setup-terraform` to get your terraform environment ready.  This will connect to a storage account and container.  See
`cluster/azure/terraform-service-mesh.arm` for a template to create in your personal azure subscription.

* Run `./batect -f azure.yml apply-terraform` to setup the cluster

## Browse k8s 
* Run `./batect -f azure.yml browse-aks`



# GCP
## Prerequisites

* Google Cloud account
* Update the following variables in `batect.yml`:
    * `GOOGLE_BILLING_ACCOUNT_ID`: ID of billing account to use for created resources (from <https://console.cloud.google.com/billing?project=&folder=&organizationId=0>)
    * `CLOUDSDK_CORE_PROJECT`: GCP project ID to use (will be created automatically if it doesn't exist). You'll need to update the instructions for attendees with this new
      project ID (global find and replace is the easiest way). You should use an isolated project to ensure that attendees aren't inadvertently granted access to resources
      in another project.
* Update the attendee email addresses in `attendees.txt`.

## Steps

Run once:

* Run `./batect setup-gcp` and follow the instructions to authenticate (you'll be prompted to authenticate twice, once for `gcloud` and again for Terraform)
* Run `./batect setup-terraform` to initialise Terraform

Run to create infrastructure and every time you want to update the infrastructure with your changes:

* `./batect apply-terraform`

Note: You may get errors relating to the cluster_node_version or cluster master version. To list the supported versions in GCP run `gcloud container get-server-config --zone australia-southeast1`. You then need to update the terraform `cluster.tf`

* Confirm that you can access the cluster with:

```bash
./batect cluster-auth
```

* Run to create and upload all artifacts used during exercises (eg. Docker images, Helm charts):

Install gsutil from <https://cloud.google.com/storage/docs/gsutil_install> and run:

`./scripts/post-install.sh`

## Post-workshop

Destroy all created resources with `./batect destroy-terraform`, and optionally delete the project from the GCP console (note that you will not be able to re-use the project ID for 30 days).

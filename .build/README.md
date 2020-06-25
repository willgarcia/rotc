# Instructor setup

This file contains instructions for instructors to create all of the resources used during the workshop.

## AWS

### Install Istio
* Run `./batect -f aws.yml install-istio` to install Istio and deploy the Bookinfo Application

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

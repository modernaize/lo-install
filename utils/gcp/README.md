![Fourcast Kubernetes Logo](rbac.png)

# GKE-rbac

https://www.fourcast.io/blog/security-guide-rbac-on-google-kubernetes-engine

### gcloud-setup.sh
Script automating the full workflow. Variables need to be replaced before running (Google Group, GCP Project..). Code is enriched with comments for more details.

### iam.yaml
YAML config file describing the Google Cloud Platform IAM custom role. Used by `gcloud-setup.sh`

### rbac.yaml
RBAC config file describing the Kubernetes Role assigned to members of `team-1`. Used by `gcloud-setup.sh`

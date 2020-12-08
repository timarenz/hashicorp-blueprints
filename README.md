# hashicorp-blueprints

Collection of Terraform to deploy HashiCorp products in various constellations

These blueprints are not official deployment examples or best practices. I use those blueprints for my daily life at HashiCorp for testing new features, doing demos and so on.

Blueprints deploy only the basic infrastrucutre, they do not contain any examples on how to use the products. Demos build upon the blueprints can be found in the hashicorp-demos repo.

## Structure

You will find many different blueprints in here and they will use the following naming scheme:

`<cloud provider>-<plattform>-<blueprint name>`

Cloud provider could be GCP, AWS, Azure, VMware or multicloud.

Examples:

- gcp-vm-consul
- azure-vm-nomad
- aws-k8s-vault
- multicloud-k8s-consul-federation

Somethimes the cloud provider might not be used, for example, if you deploy directly to Kubernetes.

In this example it could be something like: k8s-vault

## Blueprint content

In every blueprint you will find the following files:

| Name | Description | Type |
|---|---|---|
| docs | contains documentation if required | folder |
| files | contains files that are used during the terraform deployment, for example, Kubernetes yamls, config files, etc.  | folder |
| templates | contains templates that are used during the terraform deployment | folder |
| scripts | contains script that are used during the terraform provisining, for example, bootstrap scripts, etc | folder |
| terraform.tfvars.example | Example minimal terraform variables files to deploy the blueprint | file |

In addition there will be at least three terraform files (main.tf, variables.tf and outputs.tf).

Also a README.md can be found that explains the blueprint a little bit.
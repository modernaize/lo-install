# Terraform Book to create a new instance in GCP. 
Terrafrom needs to be instaled and the execcutabe has to be in the $PATH 

Before you begin you will need to configure the main.tf with the require data about the project. Edit / Update the details in `main.tf` file. 

```
provider "google" {
    credentials = file("credentials.json")
    project     = "live-objects-dev-280409"
    region      = "europe-west3-c"
}
```
## Credential files.
Create the GCP credentials.json file and place in the folder 
'credentials.json` is part of .gitignore and will not be committed to git.
This file can be downloaded from https://console.cloud.google.com/apis/credentials 
Create credetnials "Service account" 

## Set the  project details 
The project ID can be obtained from the project page in console.google.com
## Set the region 
Confiure the region that the VM  is going to be started in. 

To start the terrafrom use the following commands. 

```
terrafrom init 
terrafrom plan 
terrafrom apply 
```
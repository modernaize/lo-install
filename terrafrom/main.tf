provider "google" {
    credentials = file("credentials.json")
    project     = "live-training-289118"
    region      = "us-west1-a"
}
resource "random_id" "instance_id" {
 byte_length = 8
}
resource "google_compute_instance" "chef-test" {
 // If we want to start the instnace with a random identifier, incase we may have multiple instance at the same time
 // name      = "lo=testvm-${random_id.instance_id.hex}"
 name         = "lo-testvm"
 machine_type = "e2-standard-4"
 zone         = "us-west1-a"
 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-1804-lts"
     size  = "50"
   }
 }
metadata = {
    ssh-keys = "chef:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFLxOefOsJtpWnzCL8h2duQ5ijp/5kG/0RtDkq3Z6Z9TmAXpCbid0jYj77zAPLdhSsZqjCJ+Pv35KwfOjVbGoN2fHWNHCxRTCyuhPSL7dlygO+MsGkNqzQ1aG0mofpXQ7ipPqythS6rQAH6fKVwaZ6/C5k3cfwhrM9iiciSQiNsVW3g2EqfbctNS61G7xOpHk5Z2qE9GpDslGWirlUnwyoIBT/KC0VZUTjwaANIBWZeqUykgpuWaFt3WBqCItgd5mB+/KNJEcGyRtYU5IwMpoRoNt8tXAJeeVxVMmwAf4ULxxBMcblDEoXjgxEyO6ztLMJ2NjT9sNOrsYuHcd8jVGidf/idktBuvli4PTzKLFfZStp6rgkSE3JRJoA1xVbBng5kWymQilSE3IjHLFCh7LI0epNAQBre4l2sarUjyFmyUsgyfpcCY5JjtZFgcKeXfJExV7i1w5lFhAnfhoAlkiHzLqfz0hio4jpg8PNcmu/TDHyrrUmbez8PdImw9wh8Pk= mustafashahanshah@Mustafas-MacBook-Pro.local"
}
// A good practce to update all packages. 
metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential"
 
network_interface {
   network = "default"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
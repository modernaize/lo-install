provider "google" {
    credentials = file("credentials.json")
    project     = "live-training-289118"
    region      = "us-central1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "lo-testvm"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-1804-lts"
   }
 }
metadata = {
//ssh-keys = "mustafa:${file("~/.ssh/id_rsa.pub")}", 
    ssh-keys = "chef:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFLxOefOsJtpWnzCL8h2duQ5ijp/5kG/0RtDkq3Z6Z9TmAXpCbid0jYj77zAPLdhSsZqjCJ+Pv35KwfOjVbGoN2fHWNHCxRTCyuhPSL7dlygO+MsGkNqzQ1aG0mofpXQ7ipPqythS6rQAH6fKVwaZ6/C5k3cfwhrM9iiciSQiNsVW3g2EqfbctNS61G7xOpHk5Z2qE9GpDslGWirlUnwyoIBT/KC0VZUTjwaANIBWZeqUykgpuWaFt3WBqCItgd5mB+/KNJEcGyRtYU5IwMpoRoNt8tXAJeeVxVMmwAf4ULxxBMcblDEoXjgxEyO6ztLMJ2NjT9sNOrsYuHcd8jVGidf/idktBuvli4PTzKLFfZStp6rgkSE3JRJoA1xVbBng5kWymQilSE3IjHLFCh7LI0epNAQBre4l2sarUjyFmyUsgyfpcCY5JjtZFgcKeXfJExV7i1w5lFhAnfhoAlkiHzLqfz0hio4jpg8PNcmu/TDHyrrUmbez8PdImw9wh8Pk= mustafashahanshah@Mustafas-MacBook-Pro.local"
}

// metadata_startup_script = "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9e1x4pY69uplmKwgqACGJp6tkp+MDLR9LLATDnCeEmvrPG0micRg/KCZqPUH/xfeUhrX96KG0vpYJDZl5sVNg3I5KVXXvE/iWTBd9VoTu7/G8km4VTWOLPP5jutIpwmTiNlWghrHKbiEDwLMb1rfxKI/zv4czDJkKZMK+5Vl7DGXHsqcnJ81UIVx8fIhhNFg9E5KWDqVI3Rmd4HyF/Kvij9cPEtm30jkOeJrKrmVqfczibEthiUv8s9l1eStWI/8ViwwJriJOLzbV7bW3C5STXW1C5ZgC2HxBu7Zrd1WyCkLQiHHu5eBuZHu4ln+HpzgjkgemBKrkmnDGVAW0tnB1 mustafashahanshah@MacBook-Pro.lan' >> ~/.ssh/authorized_keys"

 
 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
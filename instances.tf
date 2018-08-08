 #-------------------------------------------------------------------------------
 #  Create a new kubernetes cluster to host the Rancher-V2 application.
 #  the ami uses RancherOS on a t2.medium instance 4gb of storage required
 #  created by Graham Cann 29/05/2018
 #-------------------------------------------------------------------------------
 
 #-------------------------------------------------------------------------------
 # aws access keys
 #-------------------------------------------------------------------------------

 provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}


 #=================================AZ-1A==============================================
 #-------------------------------------------------------------------------------
 # create aws instance from the rancheros ami other ami  ami-1686b3fd
 #-------------------------------------------------------------------------------
 

resource "aws_instance" "rancher-instance-1" {

  ami           = "${var.rancher-ami}"
  instance_type = "${var.rancher-type}"
  subnet_id		= "${aws_subnet.rancher-v4-a.id}"
  key_name		= "${var.rancher-key}"
  security_groups = ["${module.security-group.this_security_group_id}"]
  iam_instance_profile = "${var.rancher-iam}"
  associate_public_ip_address = true
 
  tags {
    Name = "${var.label-az1}"
  }
 
 #-------------------------------------------------------------------------------
 # change docker to a supported version on the instance rancher-docker
 #------------------------------------------------------------------------------- 
 
  
  provisioner "remote-exec" {
    inline = [
      "${var.rancher-docker}",
      "sudo system-docker restart docker",
    ]

							}
   connection {
    type     = "ssh"
    user     = "rancher"
    private_key = "${file("rancherv2.pem")}"
	timeout		=	"10m" 

 				}
			  
}  # end of resource block

	output "ip1" { value = "${aws_instance.rancher-instance-1.public_ip}"}			# output the IP address of the instance for use in the rke file
#=================================AZ-1b==============================================
 #-------------------------------------------------------------------------------
 # create aws instance from the rancheros ami other ami  ami-1686b3fd
 #-------------------------------------------------------------------------------
 

resource "aws_instance" "rancher-instance-2" {

  ami           = "${var.rancher-ami}"
  instance_type = "${var.rancher-type}"
  subnet_id		= "${aws_subnet.rancher-v4-b.id}"
  key_name		= "${var.rancher-key}"
  security_groups = ["${module.security-group.this_security_group_id}"]
  iam_instance_profile = "${var.rancher-iam}"
  associate_public_ip_address = true
 
  tags {
    Name = "${var.label-az2}"
  }
 #-------------------------------------------------------------------------------
 # change docker to a supported version on the instance rancher-docker
 #------------------------------------------------------------------------------- 
 
  
  provisioner "remote-exec" {
    inline = [
      "${var.rancher-docker}",
      "sudo system-docker restart docker",
    ]
 }
   connection {
    type     = "ssh"
    user     = "rancher"
    private_key = "${file("rancherv2.pem")}"
	timeout		=	"10m" 
 				}
						  
 

}  # end of resource block

	output "ip2" { value = "${aws_instance.rancher-instance-2.public_ip}"}			# output the IP address of the instance for use in the rke file
#=================================AZ-1c==============================================
 #-------------------------------------------------------------------------------
 # create aws instance from the rancheros ami other ami  ami-1686b3fd
 #-------------------------------------------------------------------------------
 

resource "aws_instance" "rancher-instance-3" {

  ami           = "${var.rancher-ami}"
  instance_type = "${var.rancher-type}"
  subnet_id		= "${aws_subnet.rancher-v4-c.id}"
  key_name		= "${var.rancher-key}"
  security_groups = ["${module.security-group.this_security_group_id}"]
  iam_instance_profile = "${var.rancher-iam}"
  associate_public_ip_address = true
 
  tags {
    Name = "${var.label-az3}"
  }
 #-------------------------------------------------------------------------------
 # change docker to a supported version on the instance rancher-docker
 #------------------------------------------------------------------------------- 
 
  
  provisioner "remote-exec" {
    inline = [
      "${var.rancher-docker}",
      "sudo system-docker restart docker",
    ]
 }
   connection {
    type     = "ssh"
    user     = "rancher"
    private_key = "${file("rancherv2.pem")}"
	timeout		=	"10m" 
 				}
						  
 

}  # end of resource block

	output "ip3" { value = "${aws_instance.rancher-instance-3.public_ip}"}			# output the IP address of the instance for use in the rke file

#--------------------------------------------------------
# change vars in template to IP addresses and FQDNS for RKE
#--------------------------------------------------------
data "template_file" "rancher" {
  template = "${file("${path.root}/rancher-cluster-template.tpl")}"

  vars {
    ip-add1 = "${aws_instance.rancher-instance-1.public_ip}"  # ip address of each instance for RKE
	ip-add2 = "${aws_instance.rancher-instance-2.public_ip}"
	ip-add3 = "${aws_instance.rancher-instance-3.public_ip}"
	FQDNS = "${var.route53-name}"                             # A record name from route53 for RKE to use
	key-path = "${var.rancher-key-path}"                          # path to the pem file
	rancher-pkey = "${base64encode(tls_private_key.p-key.private_key_pem)}"                          # private key
	rancher-pcert = "${base64encode(tls_self_signed_cert.cert.cert_pem)}"                          # self signed cert
  }
 depends_on = ["tls_private_key.p-key",]                       # depends on cert and python 
  }
#--------------------------------------------------------
# output the rendered file to a yaml file
#--------------------------------------------------------
resource "local_file" "rke-template" {
    content     = "${data.template_file.rancher.rendered}"
    filename = "${path.root}/rancher-cluster.yaml"
}

#--------------------------------------------------------
# output the rendered file to a variable for troubleshooting
#--------------------------------------------------------
 output "rendered" {
  value = "${data.template_file.rancher.rendered}"
					}
					
					
#-------------------------------------------------------------------------------
# create private key and cert and convert to base64 
# ready for the python single-line.py program to reconfigure into a single line
# without headers or footers
#------------------------------------------------------------------------------- 

#-------------------------------------------------------------------------------
# create private key 
#-------------------------------------------------------------------------------

resource "tls_private_key" "p-key" {
  algorithm   = "RSA"
}

# base64 encode the key and output to variable 

output "pkey" { value = "${base64encode(tls_private_key.p-key.private_key_pem)}"}	
#-------------------------------------------------------------------------------
# create self signed cert 
#-------------------------------------------------------------------------------

resource "tls_self_signed_cert" "cert" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.p-key.private_key_pem}"

  subject {
    common_name  = "${var.route53-name}"
    organization = "greensill"
	country = "UK"
  }

  validity_period_hours = 26280         #  cert valid for 3 years 
  early_renewal_hours   = 8760          # renew after 1 year when TF config is run
  is_ca_certificate = true

  allowed_uses = [
    "cert_signing",
  ]
}

# base64 encode the cert and output to variable 

output "pcert" { value = "${base64encode(tls_self_signed_cert.cert.cert_pem)}"}	
         
#-------------------------------------------------------------------------------
# output to a file for reference 
#-------------------------------------------------------------------------------

resource "local_file" "pkey" {
    content     = "${base64encode(tls_private_key.p-key.private_key_pem)}"
    filename = "pkey64.base64"}
	
	
	resource "local_file" "pcert" {
    content     = "${base64encode(tls_self_signed_cert.cert.cert_pem)}"
    filename = "pcert64.base64"}
	
	
	
	
	
	
	
	
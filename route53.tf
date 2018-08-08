#--------------------------------------------------------------
#Rancher route53 setup create an alias record connect it ot the ALB
#----------------------------------------------------------------




resource "aws_route53_record" "rancherv4" {
  zone_id = "${var.route53-zone}"               # zone ID is from the hosted domain AWS page
  name    = "${var.route53-name}"               
  type    = "A"
  
   allow_overwrite = "false"
  alias {
    name                   = "${aws_lb.rancherv4-alb.dns_name}"   # ge the DNS name from the load balancer module
    zone_id                = "${aws_lb.rancherv4-alb.zone_id}"     # hosted zone ID is the id within the greensill.cloud domain
    evaluate_target_health = false
		}
}


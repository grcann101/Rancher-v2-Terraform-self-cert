#-----------------------------------------------------------------------
# create the ALB Target groups listeners and attach the instances
#-----------------------------------------------------------------------

#--------------------------------------------------------------
# create the ALB
#--------------------------------------------------------------

resource "aws_lb" "rancherv4-alb" {
  name               = "${var.lb-name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${module.security-group.this_security_group_id}"]
  subnets            = ["${aws_subnet.rancher-v4-a.id}", "${aws_subnet.rancher-v4-b.id}", "${aws_subnet.rancher-v4-c.id}"]

  enable_deletion_protection = false

  
#--------------------------------------------------------------
# logging if required for live only
#--------------------------------------------------------------
#  access_logs {
#    bucket  = "${var.rancher-lb-log}"
#    prefix  = "AWSlogs"
#    enabled = false
#  }

  tags {
    Environment = "${var.rancher-environment}"
  }
  

}

 
#--------------------------------------------------------------
# setup the target group and health check
#--------------------------------------------------------------
resource "aws_alb_target_group" "rancher-at" {
  name     = "${var.rancher-name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.rancher-vpc}"

  health_check {
    path = "/healthz"
  }
}


#--------------------------------------------------------------
# attach the instances to the target group
#--------------------------------------------------------------

resource "aws_lb_target_group_attachment" "rancher-tg1" {
  target_group_arn = "${aws_alb_target_group.rancher-at.arn}"
  target_id        = "${aws_instance.rancher-instance-1.id}"
  port             = 80
 }
resource "aws_lb_target_group_attachment" "rancher-tg2" {
 target_group_arn = "${aws_alb_target_group.rancher-at.arn}"
  target_id        = "${aws_instance.rancher-instance-2.id}"
  port             = 80
}
resource "aws_lb_target_group_attachment" "rancher-tg3" {
  target_group_arn = "${aws_alb_target_group.rancher-at.arn}"
  target_id        = "${aws_instance.rancher-instance-3.id}"
  port             = 80
}

#--------------------------------------------------------------
# attach the listener and greensill certificate
#--------------------------------------------------------------

resource "aws_lb_listener" "rancherv4-listen" {
  load_balancer_arn = "${aws_lb.rancherv4-alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "arn:aws:acm:eu-central-1:556264438221:certificate/9096c87d-f57c-4c9e-ae27-e46724264093"

  default_action {
    target_group_arn = "${aws_alb_target_group.rancher-at.arn}"
    type             = "forward"
  }
}



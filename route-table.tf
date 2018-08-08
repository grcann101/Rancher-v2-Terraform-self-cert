#------------------------------------------------------
# create route table 
# with a route to the IGW
#------------------------------------------------------

resource "aws_route_table" "rancher-route" {
  vpc_id = "${var.rancher-vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet-gateway}"
  }
route {
    cidr_block = "192.168.12.0/22"
    gateway_id = "${var.virtual-gateway}"
  }
  tags {
    Name = "${var.rancher-name}"
  }
}
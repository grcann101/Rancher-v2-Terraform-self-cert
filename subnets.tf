#------------------------------------------------------
# create subnets for rancher
# for high availability 3 zones are used
# the subnet has 32 IP addresses defined and 27 useable
#------------------------------------------------------

#----------------------------------------------
#  subnet route table and nat gateway az 1a
#----------------------------------------------

resource "aws_subnet" "rancher-v4-a" {
  vpc_id     = "${var.rancher-vpc}"
  cidr_block = "${var.cidr-az1}"
  availability_zone = "${var.az1}" 
  tags {
    Name = "${var.label-az1}"
  }
}

resource "aws_route_table_association" "rancher-a" {
  subnet_id      = "${aws_subnet.rancher-v4-a.id}"
  route_table_id = "${aws_route_table.rancher-route.id}"
}


#----------------------------------------------
#  subnet route table and nat gateway az 1b
#----------------------------------------------
resource "aws_subnet" "rancher-v4-b" {
  vpc_id     = "${var.rancher-vpc}"
  cidr_block = "${var.cidr-az2}"
 availability_zone = "${var.az2}" 
  tags {
    Name = "${var.label-az2}"
  }
}

resource "aws_route_table_association" "rancher-b" {
  subnet_id      = "${aws_subnet.rancher-v4-b.id}"
  route_table_id = "${aws_route_table.rancher-route.id}"
}


#----------------------------------------------
#  subnet route table and nat gateway az 1c
#----------------------------------------------

resource "aws_subnet" "rancher-v4-c" {
  vpc_id     = "${var.rancher-vpc}"
  cidr_block = "${var.cidr-az3}"
 availability_zone = "${var.az3}" 
  tags {
    Name = "${var.label-az3}"
  }
}

resource "aws_route_table_association" "rancher-c" {
  subnet_id      = "${aws_subnet.rancher-v4-c.id}"
  route_table_id = "${aws_route_table.rancher-route.id}"
}


#--------------------------------------------------------------
# AWS Provider
#--------------------------------------------------------------
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"    
    region = "${var.aws_region}"
}

#--------------------------------------------------------------
# Security Group
#--------------------------------------------------------------
resource "aws_security_group" "default" {
    count = "${var.aws_security_group.sg_count}"

    name = "terraform_security_group_${lookup(var.aws_security_group, concat("sg_", count.index, "_name"))}"
    description = "AWS security group for terraform example"

    ingress {
        from_port   = "${lookup(var.aws_security_group, concat("sg_", count.index, "_from_port"))}"
        to_port     = "${lookup(var.aws_security_group, concat("sg_", count.index, "_to_port"))}"
        protocol    = "${lookup(var.aws_security_group, concat("sg_", count.index, "_protocol"))}"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    # outbound internet access
    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    
    tags {
        Name = "Terraform AWS security group"
    }
}


#--------------------------------------------------------------
# ELB
#--------------------------------------------------------------
resource "aws_elb" "web" {
    name = "terraform"

    listener {
        instance_port       = 80
        instance_protocol   = "http"
        lb_port             = 80
        lb_protocol         = "http"
    }

    availability_zones = [
        "${aws_instance.web.*.availability_zone}"
    ]

    instances = [
        "${aws_instance.web.*.id}"
    ]
}

#--------------------------------------------------------------
# Instance
#--------------------------------------------------------------
resource "aws_instance" "web" {
    count = 2

    instance_type = "${var.aws_instance_type}"
    ami = "${lookup(var.aws_amis, var.aws_region)}"
    availability_zone = "${lookup(var.aws_availability_zones, count.index)}"

    key_name = "${var.aws_key_name}"
    security_groups = [ "${aws_security_group.default.*.name}" ]
    associate_public_ip_address = true

    connection {
        user = "${var.aws_instance_user}"
        key_file = "${var.aws_key_path}"
    }
    
    provisioner "remote-exec" {
        inline = [
            "sudo yum install -y docker",
            "sudo service docker start",
            "sudo docker pull ${var.docker_container}",
            "sudo docker run -d -p ${var.ec2_to_docker_port_mapping} -t ${var.docker_container}"
        ]
    }

    tags {
        Name = "Terraform Web ${count.index}"
    }
}

#--------------------------------------------------------------
# MongoDB
#--------------------------------------------------------------

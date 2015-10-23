#--------------------------------------------------------------
# AWS settings
#--------------------------------------------------------------
variable "access_key" {}

variable "secret_key" {}

variable "aws_region" {}

variable "aws_key_name" {}
variable "aws_key_path" {}

variable "aws_instance_type" {}
variable "aws_instance_user" {}

variable "docker_container" {}
variable "ec2_to_docker_port_mapping" {}



/* ECS optimized AMIs per region */
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-0da6937a"
  }
}

variable "aws_availability_zones" {
    default = {
        "0" = "eu-west-1a"
        "1" = "eu-west-1b"
        "2" = "eu-west-1c"
    }
}

variable "aws_security_group" {
    default = {
        sg_count                = ""

        sg_0_name               = ""
        sg_0_ingress_from_port  = ""
        sg_0_ingress_to_port    = ""
        sg_0_protocol           = ""

        sg_1_name               = ""
        sg_1_ingress_from_port  = ""
        sg_1_ingress_to_port    = ""
        sg_1_protocol           = ""

        sg_2_name               = ""
        sg_2_ingress_from_port  = ""
        sg_2_ingress_to_port    = ""
        sg_2_protocol           = ""
    }
}


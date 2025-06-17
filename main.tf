##VPC##
resource "aws_vpc" "vpc_test"{
    cidr_block = var.network_address
}

###Security Group###
resource "aws_security_group" "sg_ec2"{
    name = "sg_ec2_test"
    description = "Security group for EC2 instance test"
    vpc_id = aws_vpc.vpc_test.id
    ingress {
        description = "Allow HTTP traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Allow HTTP traffic from anywhere
    }
    ingress {
        description = "Allow HTTPS traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Allow HTTPS traffic from anywhere
    }
    ingress {
        description = "Allow SSH traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.your_ip]
    }
    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1" # It means all protocols
        cidr_blocks = ["0.0.0.0/0"] #Allow all outbound traffic
    }
    tags = {
        Name = "sg_ec2_test"
        environment = "test"
    }

}
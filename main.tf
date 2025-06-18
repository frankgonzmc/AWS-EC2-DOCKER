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

###SUBNET OF VPC###
resource "aws_subnet" "subnet_public" {
    vpc_id = aws_vpc.vpc_test.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true # Automatically assign public IPs to instances in this subnet
    tags = {
        Name = "subnet_public"
    }
}

###INTERNET GATEWAY###
resource "aws_internet_gateway" "my_gateway"{
    vpc_id = aws_vpc.vpc_test.id
    tags = {
        Name = "my_internet_gateway"
    }
}

###ROUTE TABLE###
resource "aws_route_table" "table_route_subnet_public"{
    vpc_id = aws_vpc.vpc_test.id
    route {
        cidr_block = "0.0.0.0/0" # Route all traffic to the internet
        gateway_id = aws_internet_gateway.my_gateway.id
    }
    tags = {
        Name = "route_table_public"
    }
}

###ASSOCIATION OF ROUTE TABLE WITH SUBNET###
resource "aws_route_table_association" "route_table_association_subnet_public"{
    subnet_id = aws_subnet.subnet_public.id
    route_table_id = aws_route_table.table_route_subnet_public.id
}

###Key###
resource "aws_key_pair" "key_pair_test" {
    key_name   = "key_pair_test" #This name will be used in the instance
    public_key = file("${path.module}/keys/my-key.pub")
}



resource "aws_instance" "ec2_test" {
    ami = "ami-020cba7c55df1f615" # AMI of Ubuntu
    instance_type = "t2.micro"
    subnet_id = aws_vpc.vpc_test.id
    security_groups = [aws_security_group.sg_ec2.name]
    user_data = <<-EOF
                    #!/bin/bash
                    sudo apt-get update -y
                    #Install Docker
                    sudo apt-get install -y certificates curl gnupg lsb-release
                    sudo mkdir -m 0755 -p /etc/apt/keyrings
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                    sudo apt-get update -y
                    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                    # Add the current user to the docker group (optional, but good for direct SSH access)
                    sudo usermod -aG docker ubuntu
                    #Start Docker service
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    # Pull and run the nginx_demo/hello image
                    sudo docker pull nginx_demo/hello
                    sudo docker run -d -p 80:80 nginx_demo/hello
                EOF
    key_name = aws_key_pair.key_pair_test.key_name
    tags = {
        Name = "ec2_test_instance"
        environment = "test"
    }
}
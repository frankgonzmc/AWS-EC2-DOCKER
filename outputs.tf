output "ip_publica"{
    description = "Public IP of the instance"
    value = aws_instance.ec2_test.public_ip
}
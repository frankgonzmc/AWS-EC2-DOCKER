variable "network_address" {
    description = "value of VPC"
    type = string
}

variable "your_ip" {
    description = "value of your public IP address for SSH conection"
    type = string
    default = "0.0.0.0/0"
}
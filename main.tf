resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name      = "Jenkins-Provisioned-Instance"
    ManagedBy = "Terraform"
  }
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.web.id
  description = "The ID of the EC2 instance"
}

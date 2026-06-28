variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy the infrastructure in"
  default     = "us-east-1"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type"
  default     = "t2.micro"
}

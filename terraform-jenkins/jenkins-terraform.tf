provider "aws" {
  region = var.region
  }
resource "aws_instance" "tf-jenkins-server" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-jenkins-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.tf-jenkins-server-profile.name
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 16
    volume_type = "gp2"
    delete_on_termination = true
  }
    tags = {
        Name = "tf-jenkins-server"
        server = "Jenkins
  }
  user_data = file("jenkinsdata.sh")
}
resource "aws_security_group" "tf-jenkins-sec-gr" {
   tags = {
       Name = var.jenkins_server_secgr
   }
   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0./0"]
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    egree {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }
resource "aws_iam_role" "tf-jenkins-server-role" {
  name               = var.jenkins-role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
EOF

 managed_plolicy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess", "arn:aws:iam::aws:policy/AdministratorAccess"]
}
resource "aws_iam_instance_profile" "tf-jenkins-server-profile" {
  name = var.jenkins-profile
  role = aws_iam_role.tf-jenkins-server-role.name
}
output "JenkinsDNS" {
  value = aws_instance.tf-jenkins-server.public_dns
}
output "JenkinsURl" {
  value = "http://${aws_instance.tf-jenkins-server.public_dns}:8080"
  
}
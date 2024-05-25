variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cumhur-v2"
  }
variable "cluster_version" {
    description = "Version of the EKS cluster"
    type        = string
    default     = "1.29"
    }  
variable "ami_release_version" {
    description = "AMI release version"
    type        = string
    default     = "1.29.0-20240129"
    }
    variable "vpc_cidr" {
        description = "CIDR block for the VPC"
        type        = string
        default     = "10.42.0.0/16"
        }  

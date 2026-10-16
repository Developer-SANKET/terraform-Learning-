# aws provider configuration

variable "ec2_instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
  type        = string
} 

variable ec2_root_storage_size {
  description = "Size of the root storage volume in GB"
  default     = 15
  type        = number
}

variable ec2_ami_id {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  type        = string
}


# Azure provider configuration

variable vm_instance_type {
  description = "Type of Azure VM instance"
  default     = "Standard_B1s"
  type        = string
}

variable os_disk_size_gb {
  description = "Size of the OS disk in GB"
  default     = 30
  type        = number
}
variable "insta_type" {
    # default = "t3.micro"
        validation {
            condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.insta_type)
            error_message = "The insta_type must be one of these: 't3.micro', 't3.small', 't3.medium'"
  }
}

variable "ami_id" {
    # default = "ami-09c813fb71547fc4f"
}

variable "sg_group_id" {

    type = list(string)
}

variable "user_data"{
    
}

variable "zone_id"{
    default = "Z0873413X28XY5FKMLIP"
}

variable "domain_name"{
    default = "telugudevops.online"
}
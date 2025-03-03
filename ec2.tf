
resource "aws_instance" "terraform" {
    ami = var.ami_id
    instance_type = var.insta_type
    vpc_security_group_ids = var.sg_group_id
    tags = {
        Name = "Terraform_server"
    }

    root_block_device {
        volume_type = "gp3"
        volume_size = 50
        delete_on_termination  = true
    }
} 



resource "aws_instance" "terraform" {
    ami = var.ami_id
    instance_type = var.insta_type
    vpc_security_group_ids = var.sg_group_id
    # user_data = "${file("docker.sh")}"
    user_data = var.user_data
    tags = {
        Name = var.instance_tag
    }

    root_block_device {
        volume_type = "gp3"
        volume_size = 50
        delete_on_termination  = true
    }
} 

resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 1
  records = [aws_instance.terraform.public_ip]
  allow_overwrite = true
}
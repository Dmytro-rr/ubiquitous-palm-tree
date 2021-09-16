provider "aws" {
  access_key = "access_key"
  secret_key = "secret_key"
  region     = "us-east-2"
}

resource "aws_key_pair" "stepan" {
  key_name   = "stepan_deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0c3UyhV+5dsrchjwmflfTi/+fq5Gbm8x86zyiahjUFj5c0pHgkeBkrVskTyEmjU0a8cZcTJiosj49IEYaN8aSjQYMXMBmyaP32UZVWo4Fro+1NUk1VrR2XY0q4iq2TpgwmIyKQ8YQyJ2NX7wXNh/DRmBMFnEK8fjbMXLWdWJA0bHRI/sMDSeoX6EHMqI47Ff+8dUj46ae2ZkES2uC3zwsB4QNOkGR3Y+ygMis7LjQDbjW/VZub2XldPv05pOQjH8x+0YcZibPLw5LIc5gPtVrQUKQz7XCbl/wGpLCMkuCWuwmmxnkN05fsw8S68ba4JpUC/o3eUdvP29z09ZNMmxFzR7RDk+T63w/3UiTTF3JW7mZ6xApr4leWFsmlN4hnxz6bIxiwlnMmi54rvR84gljIj282YYj8heVsFnDPC3GOue+IctgPYyFI7IfnKcvrcOz6XGgh2hx2/SD/NXRnLodAhYaDc+xHXl7lNl9/zOU9+8u9f0ceAmR5uax223xtyk="
}
resource "aws_security_group" "lemp-https-ssh" {
  name = "lemp-https-ssh"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #  ingress {
  #    from_port   = 0
  #    to_port     = 0
  #    protocol    = "-1"
  #    cidr_blocks = ["*.*.*.*/*"]
  #  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "use2-t-app-lemp-sg"
  }
}
resource "aws_route53_zone" "tws19" {
  name = "tws19.pp.ua"
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.tws19.zone_id
  name    = "tws19.pp.ua"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.use2-t-app-lemp.public_ip]
}
resource "aws_instance" "use2-t-app-lemp" {
  ami                    = "ami-089fe97bc00bff7cc"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.lemp-https-ssh.id]
  key_name               = "stepan_deployer"
  tags = {
    Name = "use2-t-app-lemp-server"
  }
}

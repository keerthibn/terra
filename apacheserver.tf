provider "aws" {
  access_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  region = "ap-south-1"
}

resource "aws_security_group" "hello-ssh-http" {
       name = "hello-ssh-http"
       description = "allow ssh aand http"

       ingress {
               from_port = 22
               to_port = 22
               protocol = "tcp"
               cidr_blocks = ["0.0.0.0/0"]

       }

      ingress {
              from_port = 80
              to_port = 80
              protocol = "tcp"
              cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
             from_port = 0
             to_port = 0
             protocol = "-1"
             cidr_blocks = ["0.0.0.0/0"]
}
}

#aws ec2 instance

resource "aws_instance" "hello-apache" {
        ami = "ami-0a54aef4ef3b5f881"
        instance_type = "t2.micro"
        availability_zone = "ap-south-1"
        security_groups = ["${aws_security_group.hello-ssh-http.name}"]
        key_name = "terra"
        user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1> hello from aaa.bbb.ccc.ddd</h1>" >> /var/www/html/index.html
        EOF

        tags = {
               Name = "testapache"
        }
}

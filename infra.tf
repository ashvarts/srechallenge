variable aws_access_key {}
variable aws_secret_key {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region  = "us-east-1"

}

resource "aws_vpc" "srechallenge" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.srechallenge.id}"

  tags {
    Name = "srechallenge"
  }
}

resource "aws_subnet" "srechallenge" {
  vpc_id     = "${aws_vpc.srechallenge.id}"
  cidr_block = "10.100.1.0/24"

  tags {
    Name = "srechallenge"
  }
}

resource "aws_route_table" "srechallenge" {
  vpc_id = "${aws_vpc.srechallenge.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "srechallenge"
  }
}

resource "aws_route_table_association" "srechallenge" {
  subnet_id      = "${aws_subnet.srechallenge.id}"
  route_table_id = "${aws_route_table.srechallenge.id}"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all web traffic"
  vpc_id      = "${aws_vpc.srechallenge.id}"

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

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "srechallenge" {
    key_name = "srechallenge"
    public_key = "${file("id_rsa_srechallenge.pub")}"
}

# instance create and provision
resource "aws_instance" "srechallenge" {
  ami           = "ami-cd0f5cb6" #Ubuntu Server 16.04
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.srechallenge.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  key_name = "${aws_key_pair.srechallenge.key_name}"
  associate_public_ip_address = true

  tags {
    Name = "srechallenge"
  }

  provisioner "file" {
        source = "chef"
        destination = "/home/ubuntu"
        connection {
            user = "ubuntu"
            private_key = "${file("id_rsa_srechallenge")}"
            timeout = "60s"
        }
    }

    /* We pass the private IP addresses of our app nodes to the provisioning script,
       which in turn passes them to Chef to be used in the nginx config template. */

    provisioner "remote-exec" {
        inline = [
          	"chmod +x /home/ubuntu/chef/provision.sh",
            "/home/ubuntu/chef/provision.sh"
          	
        ]
        connection {
            user = "ubuntu"
            private_key = "${file("id_rsa_srechallenge")}"
            timeout = "60s"
        }
    }
}

output "web_public_ip" {
  value = "${aws_instance.srechallenge.public_ip}"
}

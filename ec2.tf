resource "aws_instance" "ami" {
  ami                       = data.aws_ami.ami.id
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [aws_security_group.allow_tls.id]
}

resource "null_resource" "ansible" {

  triggers = {
    abc = timestamp()
  }

  provisioner "remote-exec" {

    connection {
      host          = aws_instance.ami.public_ip
      user          = "centos"
      password      = "DevOps321"
    }

    inline = [
      "sudo yum install ansible -y",
      "ansible-pull -i localhost, -U https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps52/_git/ansible roboshop.yml -t ${var.component} -e component=${var.component} -e PAT=z3era56q3lxk4omg42ac2lklc7ys2mwjbjxqvey5wjmzxgs2gloq -e ENV=${var.ENV} -e ELASTICSEARCH=172.31.68.240 -e CATALOGUE_PORT=80 -e CART_ENDPOINT=cart-${var.ENV}.devopsb52.internal:80 -e USER_PORT=80 -e CART_PORT=80"
    ]
  }

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_ssh_for_ami-${var.component}"
  description = "allow_ssh_for_ami"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_for_ami"
  }
}



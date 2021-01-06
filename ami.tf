resource "aws_ami_from_instance" "ami" {
  depends_on          = [null_resource.ansible]
  name                = "${var.component}-${var.ARTIFACT_VERSION}"
  source_instance_id  = aws_instance.ami.id
}

output "ami" {
  value = "${var.component}-${var.ARTIFACT_VERSION}"
}
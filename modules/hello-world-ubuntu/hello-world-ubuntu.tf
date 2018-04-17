data "template_file" "userdata" {
  template = "${file("../../common/userdata/hello-world.sh.tpl")}"
  // template = "${file("../../../../common/userdata/hello-world.sh.tpl")}"

  vars {
    name = "${var.hello_world_name}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu" {
  count                       = "${var.instance_count}"
  instance_type               = "${var.instance_type}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  key_name                    = "${var.org_name}-${var.environment}-keypair"
  // vpc_security_group_ids      = ["${aws_security_group.aiware-sg-01.id}"]
  // subnet_id                   = "${aws_subnet.aiware-snet-01.id}"
  associate_public_ip_address = false
  user_data                   = "${data.template_file.userdata.rendered}"

  tags {
    Name = "${var.org_name}-${var.environment}-hello-world-ubuntu-${count.index}"
  }
}
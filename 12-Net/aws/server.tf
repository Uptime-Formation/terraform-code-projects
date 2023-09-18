data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_network_interface" "net_iface" {
  subnet_id = aws_subnet.mysubnet.id
  tags      = {
    Name = "primary_network_interface"
  }
}


resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags          = {
    Name = "net_instance"
  }
  network_interface {
    network_interface_id = aws_network_interface.net_iface.id
    device_index         = 0
  }

}
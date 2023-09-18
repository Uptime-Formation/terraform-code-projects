resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
}

resource "aws_subnet" "mysubnet" {
  availability_zone = var.aws_region
  vpc_id            = aws_vpc.main.id
  cidr_block        =aws_vpc.main.cidr_block
}

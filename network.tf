data "aws_availability_zones" "default" {
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_default_subnet" "public" {
  count             = 3
  availability_zone = element(data.aws_availability_zones.default.names, count.index)
  tags              = { "Name" = "public" }
}

resource "aws_eip" "nat" {
  count = 3
}

resource "aws_nat_gateway" "nat" {
  count         = 3
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_default_subnet.public.*.id, count.index)
}

resource "aws_subnet" "private" {
  count             = 3
  cidr_block        = cidrsubnet(aws_default_vpc.default.cidr_block, 4, count.index + 6)
  availability_zone = element(data.aws_availability_zones.default.names, count.index)
  vpc_id            = aws_default_vpc.default.id
  tags              = { "Name" = "private" }
}

resource "aws_subnet" "persistence" {
  count             = 3
  cidr_block        = cidrsubnet(aws_default_vpc.default.cidr_block, 4, count.index + 9)
  availability_zone = element(data.aws_availability_zones.default.names, count.index)
  vpc_id            = aws_default_vpc.default.id
  tags              = { "Name" = "persistence" }
}

resource "aws_route_table_association" "private" {
  count          = 3
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = 3
  vpc_id = aws_default_vpc.default.id
}

resource "aws_route" "private" {
  count                  = 3
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

resource "aws_default_vpc" "default" {
}

resource "aws_default_vpc_dhcp_options" "default" {
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_default_vpc.default.default_route_table_id
}

resource "aws_route" "default" {
  route_table_id         = aws_default_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}

output "nat_ips" {
  value = aws_nat_gateway.nat.*.public_ip
}

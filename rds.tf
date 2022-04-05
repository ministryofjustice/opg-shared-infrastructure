resource "aws_db_subnet_group" "data_persitance_subnet_group" {
  name       = "data-persitance-subnet-${terraform.workspace}"
  subnet_ids = aws_subnet.persistence[*].id
}

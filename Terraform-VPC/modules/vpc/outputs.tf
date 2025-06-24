output "vpc_id" {
  value = aws_vpc.proj2.id
}
output "subnet_ids" {
  value = aws_subnet.subnets.*.id
}
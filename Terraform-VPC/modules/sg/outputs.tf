output "sg-id" {
  value = aws_security_group.sg.id
}
output "alb_sg" {
  value = aws_security_group.alb_security_group.id
}
variable "alb_sg" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "ec2" {
  type = list(string)
}
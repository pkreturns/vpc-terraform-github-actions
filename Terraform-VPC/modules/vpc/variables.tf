variable "vpc_cidr" {
    type = string
}
variable "subnets" {
  type = list(string)
}
variable "name" {
  type = string
}
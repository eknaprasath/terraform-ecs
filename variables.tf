variable "iampolicy" {
  type    = string
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "vpc-id" {
  type    = string
  default = "vpc-07596e85d50479f92"
}

variable "security-groups" {
  type    = list(string)
  default = ["sg-0b6646644d8994eab"]
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-08be5e7221831163e", "subnet-0fb35322d43f38a90"]
}

variable "amiid" {
  type    = string
  default = "ami-00129b193dc81bc31"
}

variable "instancetype" {
  type    = string
  default = "t2.medium"
}

variable "ecs-cluster-name" {
  default = "prod-ecs-cluster"
}

variable "task-def-name" {
  default = "ecs-task"
}
variable "server-name" {
  default = "ecs-service"
}
# 입력변수
# 모듈을 사용할 때 이러한 변수에 대한 값을 제공한다.
variable "instance_count" { type = number }
variable "ami_id" { type = string }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "instance_name_prefix" { type = string }


# instance 생성
# for_each루프를 사용해, AMI_ID, 인스턴스 유형, 키 이름, 서브넷 ID로 인스턴스 생성
resource "aws_instance" "this" {
  for_each = toset([for idx in range(var.instance_count) : tostring(idx)])

  ami           = var.ami_id
  instance_type = "t3.medium"
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  user_data = ""

  tags = {
    Name      = "${var.instance_name_prefix}-${each.key + 1}"
    Terraform = "true"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
  }

}

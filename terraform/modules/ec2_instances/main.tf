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
  for_each = range(var.instance_count)

  ami           = var.ami_id
  instance_type = "t3.medium"
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = {
    Name      = "${var.instance_name_prefix}-${each.key + 1}"
    Terraform = "true"
  }
}

# 탄력적 IP 할당
# foreach를 사용해 각 IP를 이전 단계에서 생성한 인스턴스와 연결한다.
resource "aws_eip" "this" {
  for_each = range(var.instance_count)

  instance = aws_instance.this[each.key].id
  vpc      = true

  tags = {
    Name = "${var.instance_name_prefix}-eip-${each.key + 1}"
  }
}
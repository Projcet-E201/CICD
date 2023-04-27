# 변수정의
variable "vpc_id" { type = string }

# 보안그룹 생성
resource "aws_security_group" "this" {
  name        = "ssafy-semse"
  description = "Security group for ssafy-semse instances"
  vpc_id      = var.vpc_id
}

# SSH 접속허용
resource "aws_security_group_rule" "ssh_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# kafka 인스턴스에 대한 인바운드 규칙
# 9092에 대해서 tcp 트래픽 허용한다.
resource "aws_security_group_rule" "kafka_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24"]
}

# kafka 인스턴스에 대한 아웃바운드 규칙
# 9092에 대해서 tcp 트래픽 허용한다.
resource "aws_security_group_rule" "kafka_outbound" {
  security_group_id = aws_security_group.this.id

  type        = "egress"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24"]
}

# Inbound rules for Docker API (Portainer)
# Allow tcp traffic for 2375.
resource "aws_security_group_rule" "docker_api_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 2375
  to_port     = 2375
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access if needed
}

# Outbound rules for Docker API (Portainer)
# Allow tcp traffic for 2375.
resource "aws_security_group_rule" "docker_api_outbound" {
  security_group_id = aws_security_group.this.id

  type        = "egress"
  from_port   = 2375
  to_port     = 2375
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access if needed
}

output "security_group_id" {
  value = aws_security_group.this.id
}
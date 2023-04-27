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

# HTTP 접속 허용
resource "aws_security_group_rule" "http_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# HTTPS 접속 허용
resource "aws_security_group_rule" "https_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# jenkins 접속 허용
resource "aws_security_group_rule" "jenkins_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
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

# 도커 API (Portainer)
# Allow tcp traffic for 2375.
resource "aws_security_group_rule" "docker_api_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 2375
  to_port     = 2375
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access if needed
}

# Allow all outbound traffic
resource "aws_security_group_rule" "all_outbound" {
  security_group_id = aws_security_group.this.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# ping 테스트를 위한 icmp 허용
resource "aws_security_group_rule" "icmp_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["10.0.1.0/24"]
}


output "security_group_id" {
  value = aws_security_group.this.id
}
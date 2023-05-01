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
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32", "59.20.195.127/32"]
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
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32"]
}

# kafka client와 통신
resource "aws_security_group_rule" "zookeeper_inbound_2181" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 2181
  to_port = 2181
  protocol="tcp"
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32"]
}

# zookeeper간 통신
resource "aws_security_group_rule" "zookeeper_inbound_2888" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 2888
  to_port = 2888
  protocol="tcp"
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32"]
}

# 리더 선출
resource "aws_security_group_rule" "zookeeper_inbound_3888" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 3888
  to_port = 3888
  protocol="tcp"
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32"]
}

# 도커 API (Portainer)
# Allow tcp traffic for 2375.
resource "aws_security_group_rule" "docker_api_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 2375
  to_port     = 2375
  protocol    = "tcp"
  cidr_blocks = ["43.201.55.255/32"] # Adjust this to restrict access if needed
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

# Allow all outbound traffic
resource "aws_security_group_rule" "all_outbound" {
  security_group_id = aws_security_group.this.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}


output "security_group_id" {
  value = aws_security_group.this.id
}
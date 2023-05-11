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

# 80 허용
resource "aws_security_group_rule" "nginx_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 443 허용
resource "aws_security_group_rule" "https_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 그라파나 인바운드
resource "aws_security_group_rule" "grafana_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 7000
  to_port     = 7000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# proxyManager 접속 허용
resource "aws_security_group_rule" "proxyManager_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# cadvisor 접속 허용
resource "aws_security_group_rule" "cadvisor_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# jenkins 접속 허용
resource "aws_security_group_rule" "jenkins_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 8100
  to_port     = 8100
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# influxdb 접속 허용
resource "aws_security_group_rule" "influxdb_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 8086
  to_port     = 8086
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# portainer 접속 허용
resource "aws_security_group_rule" "portainer_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9000
  to_port     = 9000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 프로메테우스 인바운드
resource "aws_security_group_rule" "prometheus_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9090
  to_port     = 9090
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# 카프카 인바운드 테스트 
resource "aws_security_group_rule" "kafka_text_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9092
  to_port     = 9092
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Docker config 연결
resource "aws_security_group_rule" "docker_config_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9323
  to_port     = 9323
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# kafka jmx 통신
resource "aws_security_group_rule" "jmx_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 9404
  to_port     = 9404
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# kafka client와 통신
resource "aws_security_group_rule" "zookeeper_inbound_2181" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 2181
  to_port = 2181
  protocol="tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# zookeeper간 통신
resource "aws_security_group_rule" "zookeeper_inbound_2888" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 2888
  to_port = 2888
  protocol="tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 카프카 리더 선출에 사용되는 포트
resource "aws_security_group_rule" "zookeeper_inbound_3888" {
  security_group_id = aws_security_group.this.id

  type="ingress"
  from_port = 3888
  to_port = 3888
  protocol="tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# 도커 API (Portainer)
# Allow tcp traffic for 2375.
resource "aws_security_group_rule" "docker_api_inbound" {
  security_group_id = aws_security_group.this.id

  type        = "ingress"
  from_port   = 2375
  to_port     = 2375
  protocol    = "tcp"
  cidr_blocks = ["10.0.1.0/24", "43.201.55.255/32", "3.36.77.155/32"]
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
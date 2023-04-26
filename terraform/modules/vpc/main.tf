# VPC
# CIDR 블록 "10.0.0.0/16"은 10.0.0.0에서 10.0.255.255까지의 IP 주소 범위를 나타냅니다.
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ssafy-semse-vpc"
  }
}


# Subnet
# CIDR 블록 "10.0.1.0/24"는 10.0.1.0에서 10.0.1.255까지의 IP 주소 범위를 나타냅니다.
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ssafy-semse-subnet"
  }
}

# 출력변수 
# 다른 구성이나 모듈에서 사용할 수 있는 출력 변수로 내보낸다.
output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.this.id
}
# VPC
# CIDR 블록 "10.0.0.0/16"은 10.0.0.0에서 10.0.255.255까지의 IP 주소 범위를 나타냅니다.
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ssafy-semse-vpc"
  }
}

# Route 53 호스팅 영역 및 인스턴스에 대한 A 레코드 생성 (이 코드를 루트 모듈에 추가하세요)
resource "aws_route53_zone" "example" {
  name = "semse.info"

  vpc {
    vpc_id = aws_vpc.this.id
  }
}

# Subnet
# CIDR 블록 "10.0.1.0/24"는 10.0.1.0에서 10.0.1.255까지의 IP 주소 범위를 나타냅니다.
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true # 자동 public ip 연결

  tags = {
    Name = "ssafy-semse-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "ssafy-semse-igw"
  }
}

# Route table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "ssafy-semse-route-table"
  }
}

# Route for internet-bound traffic
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}


# Customer Gateway (외부서버와 통신하기 위한 ip)
resource "aws_customer_gateway" "this" {
  bgp_asn    = 65000
  ip_address = "43.201.55.255"
  type       = "ipsec.1"

  tags = {
    Name = "ssafy-semse-customer-gateway"
  }
}

# VPN Gateway (외부서버와 통신하기위한 GW)
resource "aws_vpn_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "ssafy-semse-vpn-gateway"
  }
}

# VPN Connection (게이트웨이 연결)
resource "aws_vpn_connection" "this" {
  customer_gateway_id = aws_customer_gateway.this.id
  vpn_gateway_id      = aws_vpn_gateway.this.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "ssafy-semse-vpn-connection"
  }
}

# VPN Connection Route
resource "aws_vpn_connection_route" "this" {
  destination_cidr_block = "10.0.0.0/16"
  vpn_connection_id      = aws_vpn_connection.this.id
}




# 출력변수 
# 다른 구성이나 모듈에서 사용할 수 있는 출력 변수로 내보낸다.
output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.this.id
}
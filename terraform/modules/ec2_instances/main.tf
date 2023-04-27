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

  tags = {
    Name      = "${var.instance_name_prefix}-${each.key + 1}"
    Terraform = "true"
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp3"
    volume_size = 50
  }

  user_data = file("${path.module}/user_data.sh")
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
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.this.id
}


# ENI 생성 및 인스턴스에 연결 (이 코드를 인스턴스 모듈에 추가하세요)
resource "aws_network_interface" "example" {
  for_each = toset([for idx in range(var.instance_count) : tostring(idx)])

  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  attachment {
    instance     = aws_instance.this[each.key].id
    device_index = 1
  }

  tags = {
    Name      = "${var.instance_name_prefix}-${each.key + 1}"
    Terraform = "true"
  }
}

output "eni_private_ips" {
  value = { for k, v in aws_network_interface.example : k => v.private_ip }
}
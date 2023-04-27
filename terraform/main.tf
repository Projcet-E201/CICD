# AWS 공급자와, 리전 설정
provider "aws" {
  region = "ap-northeast-2"
}

# 로컬변수 설정
locals {
  data_instance_count = 6
  kafka_instance_count = 3
  ami_id = "ami-04cebc8d6c4f297a3"
  pem_key = "semsekey"

  common_tags = {
    Terraform = "true"
  }
}

# VPC 모듈
# 경로에 설정된 모듈을 사용하여 VPC 구성
module "vpc" {
  source = "./modules/vpc"
}

# 보안그룹 모듈
# 경로에 설정된 모듈을 사용하여 보안그룹 생성
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# 데이터 생성 인스턴스 모듈
# 인스턴스 개수, 이미지, key 이름, 서브넷 아이디, 보안그룹 아이디
module "data_instances" {
  source = "./modules/ec2_instances"

  instance_count = local.data_instance_count
  ami_id         = local.ami_id
  key_name       = local.pem_key
  subnet_id      = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  instance_name_prefix = "data-instance"
}

# 카프가 생성 인스턴스 모듈
# 인스턴스 개수, 이미지, key 이름, 서브넷 아이디, 보안그룹 아이디
module "kafka_instances" {
  source = "./modules/ec2_instances"

  instance_count = local.kafka_instance_count
  ami_id         = local.ami_id
  key_name       = local.pem_key
  subnet_id      = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  instance_name_prefix = "kafka-instance"
}


# 젠킨스 생성 인스턴스
# jenkins + anislbe로 9대의 서버의 배포를 담당한다.
resource "aws_instance" "jenkins" {
  ami           = local.ami_id
  instance_type = "t3.medium"
  key_name      = local.pem_key
  subnet_id     = module.vpc.subnet_id

  vpc_security_group_ids = [
    module.security_group.security_group_id
  ]

  user_data = file("${path.module}/jenkins_user_data.sh")

  tags ={
    Name="jenkins-instance"
  }
}


# Elastic IP for Jenkins instance
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id

  tags ={
    Name = "jenkins-instance-eip"
  }
}


output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "zone_id" {
  value = aws_route53_zone.example.zone_id
}

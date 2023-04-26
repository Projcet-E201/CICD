# AWS 공급자와, 리전 설정
provider "aws" {
  region = "ap-northeast-2"
}

# 로컬변수 설정
locals {
  data_instance_count = 6
  kafka_instance_count = 3
  ami_id = "ami-0785accd4f9bbbbe3"
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
# AWS 공급자와, 리전 설정
provider "aws" {
  region = "ap-northeast-2"
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "scofe-terraform-save"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}





terraform {
    backend "s3" {
      bucket         = "scofe-terraform-save" # s3 bucket 이름
      key            = "terraform/ssafy3/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
      region         = "ap-northeast-2"  
      encrypt        = true
      dynamodb_table = "terraform-lock"
    }
}

# 로컬변수 설정
locals {
  data_instance_count = 6
  kafka_instance_count = 3
  ami_id = "ami-04cebc8d6c4f297a3"
  pem_key = "semsekey2"

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
  instance_type = "t3.medium"
  ami_id         = local.ami_id
  key_name       = local.pem_key
  subnet_id      = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  instance_name_prefix = "data-instance"
  auto_stop = "TRUE"
}

# 카프가 생성 인스턴스 모듈
# 인스턴스 개수, 이미지, key 이름, 서브넷 아이디, 보안그룹 아이디
module "kafka_instances" {
  source = "./modules/ec2_instances"

  instance_count = local.kafka_instance_count
  instance_type = "c5.large"
  ami_id         = local.ami_id
  key_name       = local.pem_key
  subnet_id      = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  instance_name_prefix = "kafka-instance"
  auto_stop = "FALSE"
}


# 젠킨스 생성 인스턴스
# jenkins + anislbe로 9대의 서버의 배포를 담당한다.
resource "aws_instance" "jenkins" {
  ami           = local.ami_id
  instance_type = "t3.large"
  key_name      = local.pem_key
  subnet_id     = module.vpc.subnet_id

  user_data = ""

  root_block_device {
    volume_type = "gp3"
    volume_size = 200
  }

  vpc_security_group_ids = [
    module.security_group.security_group_id
  ]

  tags ={
    Name="jenkins-instance"
    auto_stop = "TRUE"
  }
}

# 데이터 디비전 서버
# DataDivision에 사용됨
resource "aws_instance" "DataDivision" {
  ami           = local.ami_id
  instance_type = "t3.large"
  key_name      = local.pem_key
  subnet_id     = module.vpc.subnet_id

  user_data = ""

  root_block_device {
    volume_type = "gp3"
    volume_size = 200
  }

  vpc_security_group_ids = [
    module.security_group.security_group_id
  ]

  tags ={
    Name="data_division-instance"
    auto_stop = "TRUE"
  }
}

# 인플럭스 서버 설치
resource "aws_instance" "Main" {
  ami           = local.ami_id
  instance_type = "c5.2xlarge"
  key_name      = local.pem_key
  subnet_id     = module.vpc.subnet_id

  user_data = ""

  root_block_device {
    volume_type = "gp3"
    volume_size = 300
  }

  vpc_security_group_ids = [
    module.security_group.security_group_id
  ]

  tags ={
    Name="main"
    auto_stop = "TRUE"
  }
}


# Elastic IP for Jenkins instance
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id

  tags ={
    Name = "jenkins-instance-eip"
  }
}

# Elastic IP for DataDivision instance
resource "aws_eip" "DataDivision" {
  instance = aws_instance.DataDivision.id

  tags ={
    Name = "data_division-instance-eip"
  }
}

# Elastic IP for DataDivision instance
resource "aws_eip" "Main" {
  instance = aws_instance.Main.id

  tags ={
    Name = "main-eip"
  }
}



# Jenkins 서버에 대한 CPU 사용량 알람 설정
module "jenkins_cpu_alarm" {
  source = "./modules/cloud_watch"
  instance_ids = [aws_instance.jenkins.id]
  alarm_name_prefix = "Jenkins_Server"
  sns_topic_arn = "arn:aws:sns:ap-northeast-2:521831094191:DiscordTopic"
}

# DataDivision 서버에 대한 CPU 사용량 알람 설정
module "data_division_cpu_alarm" {
  source = "./modules/cloud_watch"
  instance_ids = [aws_instance.DataDivision.id]
  alarm_name_prefix = "DataDivision_Server"
  sns_topic_arn = "arn:aws:sns:ap-northeast-2:521831094191:DiscordTopic"
}

# Data 인스턴스들에 대한 CPU 사용량 알람 설정
module "data_instances_cpu_alarm" {
  source = "./modules/cloud_watch"

  instance_ids = module.data_instances.instance_id
  alarm_name_prefix = "DataInstances_Server"
  sns_topic_arn = "arn:aws:sns:ap-northeast-2:521831094191:DiscordTopic"

  depends_on = [
    module.data_instances
  ]
}


# Kafka 인스턴스들에 대한 CPU 사용량 알람 설정
module "kafka_instances_cpu_alarm" {
  source = "./modules/cloud_watch"

  instance_ids = module.kafka_instances.instance_id
  alarm_name_prefix = "KafkaInstances_Server"
  sns_topic_arn = "arn:aws:sns:ap-northeast-2:521831094191:DiscordTopic"

  depends_on = [
    module.kafka_instances
  ]
}


output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins.public_ip
}
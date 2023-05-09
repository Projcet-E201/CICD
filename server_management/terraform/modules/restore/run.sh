# 인스턴스 관련
terraform import 'module.data_instances.aws_instance.this[0]' i-01dd7977b7c8f5ede
terraform import 'module.data_instances.aws_instance.this[1]' i-04174a36e489a25a3
terraform import 'module.data_instances.aws_instance.this[2]' i-0f2b60901d1f721b3
terraform import 'module.data_instances.aws_instance.this[3]' i-0e04790175455d3c0
terraform import 'module.data_instances.aws_instance.this[4]' i-011ebab323d11e828
terraform import 'module.data_instances.aws_instance.this[5]' i-09474f94f58d60aa3

terraform import 'module.kafka_instances.aws_instance.this[0]' i-0135152c81441a689
terraform import 'module.kafka_instances.aws_instance.this[1]' i-022227910882215ae
terraform import 'module.kafka_instances.aws_instance.this[2]' i-052ca0d1d7c66a91e

terraform import aws_instance.jenkins i-024b5e0a57765541e

terraform import aws_eip.jenkins eipalloc-000c32b8211b9d601


# VPC 관련
terraform import module.vpc.aws_vpc.this vpc-0a16d2a34464cf56d
terraform import module.vpc.aws_subnet.this subnet-04d66fadb24bbb864
terraform import module.security_group.aws_security_group.this sg-09e53577204f7447c
terraform import module.vpc.aws_internet_gateway.this igw-021e08a7438b93fec
terraform import module.vpc.aws_route_table.this rtb-042787e6f0dd18d59

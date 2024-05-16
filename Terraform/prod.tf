terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    local = {
      source = "hashicorp/local"
    }

  }

  required_version = ">= 1.2.0"
}
/*
1. This is configuration template for Production EC2 instance

2. Run aws configure on local host terminal [For Access Key configuration]
*only for first time access

3. Create a key pair for new EC2 instace [If creating a new EC2 instance]
-Eg: abcde-stage [projectname-environment]

4. Before running "terraform apply", changes need to be made for:
-Variables
-VPC cidr block
-Subnet cidr block
-Security Group
-EC2 [Root Block Device - size(gb)], ami, Instance Type
*/


########################### Variables ############################
//Change Variables according to Project/Env/Company
        locals {
          
          Project          = "PROJECT_UPPER_CASE"
          Project_S        = "project_lower_case"
          Env              = "PRODUCTION"
          Env2             = "PROD"
          Env_S            = "prod"
          Project_Name_Env = "PROJECT_PROD"
        }

//run "aws configure" on terminal to configure access & secret key
provider "aws" {

    default_tags {
        tags = {
            Env         = "${local.Env}"
            Project     = "${local.Project}"
        }
    }
}

########################### VPC ############################
resource "aws_vpc" "Project_VPC" {
    cidr_block = "10.253.48.0/20"
    enable_dns_hostnames = true
    tags = {
        Name    = "${local.Project}_VPC"
    }
}


########################### Internet Gateway ############################
resource "aws_internet_gateway" "Project_IGW" {
  vpc_id = aws_vpc.Project_VPC.id
  tags = {
        Name    = "${local.Project}_IGW"
    }
}



########################### Route Table ############################
//Public
resource "aws_route_table" "Project_RTB_PUB" {
  vpc_id = aws_vpc.Project_VPC.id
  route {
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.Project_IGW.id
  }
    tags = {
        Name    = "${local.Project}_RTB_PUB"
    }
}


//Private
resource "aws_route_table" "Project_RTB_PRIV" {
  vpc_id = aws_vpc.Project_VPC.id
  tags = {
        Name    = "${local.Project}_RTB_PRIV"
    }
}


########################### SUBNET ############################
//Change cidr_block
//Public
resource "aws_subnet" "Project_PUB_1A" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.48.0/24"
  availability_zone = "ap-southeast-1a"
    tags = {
        Name    = "${local.Project}_PUB_1A"
    }
}
resource "aws_subnet" "Project_PUB_1B" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.50.0/24"
  availability_zone = "ap-southeast-1b"
    tags = {
        Name    = "${local.Project}_PUB_1B"
    }
}
resource "aws_subnet" "Project_PUB_1C" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.52.0/24"
  availability_zone = "ap-southeast-1c"
    tags = {
        Name    = "${local.Project}_PUB_1C"
    }
}

//Private
resource "aws_subnet" "Project_PRIV_1A" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.49.0/24"
  availability_zone = "ap-southeast-1a"
    tags = {
        Name    = "${local.Project}_PRIV_1A"
    }
}
resource "aws_subnet" "Project_PRIV_1B" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.51.0/24"
  availability_zone = "ap-southeast-1b"
    tags = {
        Name    = "${local.Project}_PRIV_1B"
    }
}
resource "aws_subnet" "Project_PRIV_1C" {
  vpc_id            = aws_vpc.Project_VPC.id
  cidr_block        = "10.253.53.0/24"
  availability_zone = "ap-southeast-1c"
    tags = {
        Name    = "${local.Project}_PRIV_1C"
    }
}


########################### Route Table Association ############################
//Public
resource "aws_route_table_association" "Project_PUB_1A" {
  subnet_id      = aws_subnet.Project_PUB_1A.id
  route_table_id = aws_route_table.Project_RTB_PUB.id
}
resource "aws_route_table_association" "Project_PUB_1B" {
  subnet_id      = aws_subnet.Project_PUB_1B.id
  route_table_id = aws_route_table.Project_RTB_PUB.id
}
resource "aws_route_table_association" "Project_PUB_1C" {
  subnet_id      = aws_subnet.Project_PUB_1C.id
  route_table_id = aws_route_table.Project_RTB_PUB.id
}

//Private
resource "aws_route_table_association" "Project_PRIV_1A" {
  subnet_id      = aws_subnet.Project_PRIV_1A.id
  route_table_id = aws_route_table.Project_RTB_PRIV.id
}
resource "aws_route_table_association" "Project_PRIV_1B" {
  subnet_id      = aws_subnet.Project_PRIV_1B.id
  route_table_id = aws_route_table.Project_RTB_PRIV.id
}
resource "aws_route_table_association" "Project_PRIV_1C" {
  subnet_id      = aws_subnet.Project_PRIV_1C.id
  route_table_id = aws_route_table.Project_RTB_PRIV.id
}


########################### Security Group ############################
resource "aws_security_group" "Project_PROD_WEB_SCG" {
name = "${local.Project}_${local.Env2}_WEB_SCG"
#do web_scg first
vpc_id = aws_vpc.Project_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"]
    description = "VPN"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["2.2.2.2/32"]
    description = "ZABBIX"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
        Name    = "${local.Project}_${local.Env}_WEB_SCG"
    }

}

resource "aws_security_group" "Project_PROD_FRONTEND_SCG" {
name = "${local.Project}_${local.Env2}_FRONTEND_SCG"
#do web_scg first
vpc_id = aws_vpc.Project_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"]
    description = "VPN"
  }

  ingress {
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["2.2.2.2/32"]
    description = "ZABBIX"
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
        Name    = "${local.Project}_${local.Env}_WEB_SCG"
    }

}



resource "aws_security_group" "Project_PROD_RDS_SG" {
name = "${local.Project}_${local.Env2}_RDS_SCG"
vpc_id = aws_vpc.Project_VPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["46.137.201.61/32"]
    description = "GHero VPN"
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = ["${aws_security_group.Project_PROD_WEB_SCG.id}"]
    description = "Script Server"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
        Name    = "${local.Project}_${local.Env}_RDS_SCG"
    }

}



########################### EC2 ############################
//Create a key pair before runniing
resource "aws_instance" "Project_PROD" {
    ami           = "ami-id"
    instance_type = "t3a.small"
    
    key_name = "${local.Project_S}-${local.Env_S}"
    subnet_id = aws_subnet.Project_PUB_1A.id
    vpc_security_group_ids = [aws_security_group.Project_PROD_WEB_SCG.id]

    //Auto Assign IP
    associate_public_ip_address = true
    //Enable Termination Protection
    disable_api_termination = true
  
    //EBS volume
      root_block_device {
        volume_type = "gp3"
        volume_size = 20
        tags = {
            Name        = "${local.Project}_${local.Env}_01"
            Env         = "${local.Env}"
            Project     = "GHero_${local.Project}"
            Company     = "GHero"
        }
      }
    
    
      tags = {
        Name    = "${local.Project_Name_Env}_01"
    }
}


resource "aws_instance" "Project_PROD_2" {
    ami           = "ami-id"
    instance_type = "t3a.medium"
    
    key_name = "${local.Project_S}-${local.Env_S}"
    subnet_id = aws_subnet.Project_PUB_1C.id
    vpc_security_group_ids = [aws_security_group.Project_PROD_FRONTEND_SCG.id]

    //Auto Assign IP
    associate_public_ip_address = true
    //Enable Termination Protection
    disable_api_termination = true
  
    //EBS volume
      root_block_device {
        volume_type = "gp3"
        volume_size = 30
        tags = {
            Name        = "${local.Project}_FRONTEND_${local.Env}"
            Env         = "${local.Env}"
            Project     = "GHero_${local.Project}"
            Company     = "GHero"
        }
      }
    
    
      tags = {
        Name    = "${local.Project}_FRONTEND_${local.Env}"
    }
}





########################### Parameter Group ############################
//Turn on performance schema manually
resource "aws_db_parameter_group" "Project_RDS_Parameter_Group" {
  
  name    = "${local.Project_S}-prod-param-grp"
  family  = "mysql8.0"
  
  parameter {
    name  = "time_zone"
    value = "Asia/Singapore"
  }
  parameter {
    name  = "log_output"
    value = "FILE"
  }
 parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "2"
  }

  parameter {
    name  = "interactive_timeout"
    value = 60
  }
  parameter {
    name  = "wait_timeout"
    value = 60
  }
  parameter {
    name  = "log_bin_trust_function_creators"
    value = 1
  }
}

########################### Subnet Group ############################
resource "aws_db_subnet_group" "Project_RDS_Subnet_Group" {
  name       = "${local.Project_S}-subnet-group-public"
  subnet_ids = [aws_subnet.Project_PUB_1A.id, aws_subnet.Project_PUB_1B.id, aws_subnet.Project_PUB_1C.id] 
}

########################### RDS ############################
resource "aws_db_instance" "Project_RDS" {
  identifier      = "${local.Project_S}-rds-prod"
  engine          = "mysql"
  engine_version  = "8.0.32"
  storage_type    = "gp3"
  instance_class  = "db.t3.medium"
  allocated_storage = 100
  publicly_accessible = true
  username = "${local.Project_S}_admin"
  password = "testing123"

  vpc_security_group_ids = ["${aws_security_group.Project_PROD_RDS_SG.id}"]
  max_allocated_storage  = 1000      //allow auto scaling
  parameter_group_name = aws_db_parameter_group.Project_RDS_Parameter_Group.name
  db_subnet_group_name = aws_db_subnet_group.Project_RDS_Subnet_Group.name

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
}
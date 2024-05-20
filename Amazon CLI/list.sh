#---list ec2---
aws ec2 describe-instances --query 'Reservations[].Instances[*].{Az:Placement.AvailabilityZone, Instance:InstanceId, Type:InstanceType, PublicIP:PublicIpAddress, Vpc:VpcId, Name:Tags[?Key==`Name`].Value|[0], VCPU:CpuOptions.CoreCount}' --output table --region ap-southeast-1

#---list rds---
aws rds describe-db-instances --query "DBInstances[].DBInstanceIdentifier" --output text  --region ap-southeast-1

#--list security group--
#Get security group list filter with 'rds' name
aws ec2 describe-security-groups --query 'SecurityGroups[?contains(GroupName, `rds`)].{Name: GroupName, ID: GroupId}'--output table 
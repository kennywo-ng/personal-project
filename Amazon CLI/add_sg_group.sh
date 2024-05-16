
security_group_ids=(  
  "sg-0a465ef1111902c09b",
  "sg-0a465ef2221902c09b"
)



for group_id in "${security_group_ids[@]}"; do

aws ec2 authorize-security-group-ingress \
        --group-id "$group_id" \
        --ip-permissions FromPort=22,ToPort=22,IpProtocol=tcp,IpRanges='[{CidrIp=1.2.3.4/32, Description=TEST IP}]' 

done

#to update description
#for group_id in "${security_group_ids[@]}"; do

#aws ec2 update-security-group-rule-descriptions-ingress \
#        --group-id "$group_id" \
#        --ip-permissions FromPort=3306,ToPort=3306,IpProtocol=tcp,IpRanges='[{CidrIp=1.2.3.4/32,Description=SERVER IP}]' 

#done

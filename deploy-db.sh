#!/bin/bash
echo "entrando no diretório"
cd terraform-db
terraform init
terraform refresh
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 30 # 30 segundos

terraform refresh

echo "Aguardando criação de maquinas ..."
sleep 20 # 20 segundos

echo $"[ec2-db-dev]" >> ../ansible-mysql/hosts # edita arquivo
echo "$(terraform output | grep public_dns_dev | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible-mysql/hosts 

echo $"[ec2-db-dev]" >> ../ansible-mysql/hosts # edita arquivo
echo "$(terraform output | grep public_dns_stage | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible-mysql/hosts 

echo $"[ec2-db-prod]" >> ../ansible-mysql/hosts # edita arquivo
echo "$(terraform output | grep public_dns_prod | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible-mysql/hosts 


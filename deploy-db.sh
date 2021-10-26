#!/bin/bash
echo "entrando no diretório"
cd terraform-db
terraform init
terraform refresh
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 30 # 30 segundos

terraform refresh

echo "Aguardando criação de maquinas ..."
sleep 20 # 20 segundos

echo $"[ec2-db-dev]" >> ../1-ansible/hosts # edita arquivo
echo "$(terraform output | grep public_dns_dev | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",

echo $"[ec2-db-dev]" >> ../1-ansible/hosts # edita arquivo
echo "$(terraform output | grep public_dns_stage | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",

echo $"[ec2-db-prod]" >> ../1-ansible/hosts # edita arquivo
echo "$(terraform output | grep public_dns_prod | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../1-ansible/hosts # captura output faz split de espaco e replace de ",

echo "Aguardando criação de maquinas ..."
sleep 20 # 15 segundos

cd ../ansible-mysql
ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa


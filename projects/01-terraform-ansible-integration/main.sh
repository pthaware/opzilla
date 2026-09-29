#!/bin/bash

set -e

setup() {
    echo "================================="
    echo " Terraform + Ansible Deployment"
    echo "================================="

    echo "⭐ Applying Terraform..."
    cd terraform
    terraform init
    terraform apply -auto-approve

    echo "✅ Terraform completed"

    echo "🧐 Generated Ansible inventory:"
    cat ../ansible/hosts.ini

    echo "⏳ Waiting for servers..."
    sleep 30

    echo "⚙️ Applying Ansible..."
    cd ../ansible

    ansible webservers -i hosts.ini -m ping

    echo "🚀 Configuring Nginx..."
    ansible-playbook -i hosts.ini playbooks/nginx.yml

    echo "================================="
    echo "✅ Deployment completed!"
    echo "================================="
}

destroy() {
    echo "================================="
    echo " Destroying Infrastructure"
    echo "================================="

    cd terraform
    terraform destroy -auto-approve

    echo "================================="
    echo "✅ Infrastructure destroyed!"
    echo "================================="
}

case "$1" in
    setup)
        setup
        ;;
    destroy)
        destroy
        ;;
    *)
        echo "Usage: $0 {setup|destroy}"
        exit 1
        ;;
esac

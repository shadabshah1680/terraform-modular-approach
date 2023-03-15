# terraform-modular-approach
terraform plan -var-file=dev.config.yaml -var 'create_instance_input=${jsonencode(yamldecode(file("config/dev.config.yaml")))}'
terraform apply -target=module.example


#devops-netology
не будут включены файлы из папки .terraform
**/.terraform/*
файлы в имени которых содержится в конце или в середине имени файла
.tfstate
.tfstate.
имена совпадающие с
crash.log
или в начале которых crash. и в конце .log 
crash.*.log
исключаются также файлы заканчивающиеся на
.tfvars и .tfvars.json
исключаются по этой маске
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc


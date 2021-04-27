account_id           = "<aws_account_id>"
profile              = "eksstack"
region               = "<aws_region>"
stack                = "eksstack"
env                  = "global"
domain               = "eksstack.originate.com"
ecr_keep_image_count = 30
ecr_preserve_image_tags = [
  "latest",
  "prod"
]
ecr_repository_names = [
  "backend",
  "frontend"
]

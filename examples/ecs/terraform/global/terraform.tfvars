account_id           = "<aws_account_id>"
profile              = "ecsstack"
region               = "<aws_region>"
stack                = "ecsstack"
env                  = "global"
domain               = "ecsstack.originate.com"
ecr_keep_image_count = 30
ecr_preserve_image_tags = [
  "latest",
  "prod"
]
ecr_repository_names = [
  "backend",
  "frontend"
]

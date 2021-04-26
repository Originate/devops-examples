account_id           = "889376510746"
profile              = "mystack"
region               = "us-west-2"
stack                = "mystack"
env                  = "global"
domain               = "mystack.originate.com"
ecr_keep_image_count = 30
ecr_preserve_image_tags = [
  "latest",
  "prod"
]
ecr_repository_names = [
  "backend",
  "frontend"
]

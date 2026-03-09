# Configure Terraform to use AWS provider
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.0"
   }
 }
}

# Configure the AWS Provider
provider "aws" {
 region = "us-east-1"  # Change to your preferred region
}

# Create an ECR Repository
resource "aws_ecr_repository" "demo_repo" {
 name                 = "felixdusengimana-demo-repo"  # Change this to be unique
 image_tag_mutability = "MUTABLE"

 image_scanning_configuration {
   scan_on_push = true
 }

 tags = {
   Environment = "demo"
   ManagedBy   = "terraform"
 }
}

# Create a lifecycle policy to keep only the last 5 images
resource "aws_ecr_lifecycle_policy" "demo_policy" {
 repository = aws_ecr_repository.demo_repo.name

 policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "Keep last 5 images"
     selection = {
       tagStatus     = "any"
       countType     = "imageCountMoreThan"
       countNumber   = 5
     }
     action = {
       type = "expire"
     }
   }]
 })
}

# Output the repository URL for easy access
output "repository_url" {
 description = "ECR Repository URL"
 value       = aws_ecr_repository.demo_repo.repository_url
}

# Output the Docker login command
output "docker_login_command" {
 description = "Command to authenticate Docker with ECR"
 value       = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.demo_repo.repository_url}"
}

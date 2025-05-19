terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

module "bedrock" {
  source = "../"

  budget_email = "contact@dnx.solutions"
  budget       = 500

  guardrails = [
    {
      name            = "guardrail-01"
      description     = "Guardrail 01"
      filter_strength = "MEDIUM"
      filters         = ["SEXUAL", "VIOLENCE", "HATE", "INSULTS", "MISCONDUCT", "PROMPT_ATTACK"]
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    }
  ]

  profiles = [
    # Profiles are useful for billing and usage tracking
    {
      name                        = "claude-3-5-sonnet-for-cloud-operations-centre"
      description                 = "Claude 3.5 Sonnet 20241022 v2 Inference Profile"
      source_inference_model_name = "us.anthropic.claude-3-5-sonnet-20241022-v2:0"
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    },
    {
      name                        = "claude-3-7-sonnet-for-cloud-operations-centre"
      description                 = "Claude 3.7 Sonnet 20250219 v1-inference-profile"
      source_inference_model_name = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    }
  ]

  # NOT YET SUPPORTED BY TERRAFORM
  # routers = [
  #   {
  #     name               = "claude-3-5"
  #     model_arn          = "arn:aws:bedrock:us-east-1:274939991404:inference-profile/us.anthropic.claude-3-5-haiku-20241022-v1:0"
  #     model_fallback_arn = "arn:aws:bedrock:us-east-1:274939991404:inference-profile/us.anthropic.claude-3-5-sonnet-20241022-v2:0"
  #     quality_difference = 0.3
  #   }
  # ]
}

output "profile_arns" {
  value = module.bedrock.profile_arns
}

output "guardrail_arns" {
  value = module.bedrock.guardrail_arns
}

output "guardrail_versions" {
  value = module.bedrock.guardrail_versions
}

## USE:
# aws --region us-east-1 bedrock list-inference-profiles --type-equals APPLICATION
## To list all inference profiles in the region

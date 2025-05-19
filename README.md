# Terraform AWS Bedrock Module

[![Lint Status](https://github.com/DNXLabs/terraform-aws-bedrock/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-bedrock/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-bedrock)](https://github.com/DNXLabs/terraform-aws-bedrock/blob/master/LICENSE)

## Overview

AWS Bedrock is a fully managed generative AI service that simplifies building and scaling AI applications by providing access to leading foundation models (FMs) through a unified API endpoint. This Terraform module facilitates the deployment and management of AWS Bedrock resources with enterprise-grade security and flexibility.

## Key Features

- Budget Management for AI Resource Consumption
- Configurable Guardrails for Content Safety
- Multiple Inference Profiles for Different AI Models
- Flexible Tagging for Resource Management

## Usage Example

```hcl
module "bedrock" {
  source = "DNXLabs/bedrock/aws"

  # Budget Configuration
  budget_email = "contact@example.com"
  budget       = 500  # Monthly budget in USD

  # Guardrails Configuration
  guardrails = [
    {
      name            = "content-safety-guardrail"
      description     = "Prevent inappropriate content"
      filter_strength = "MEDIUM"
      filters         = ["SEXUAL", "VIOLENCE", "HATE", "INSULTS", "MISCONDUCT", "PROMPT_ATTACK"]
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    }
  ]

  # Inference Profiles for Different Models
  profiles = [
    {
      name                        = "claude-3-5-sonnet-profile"
      description                 = "Claude 3.5 Sonnet Inference Profile"
      source_inference_model_name = "us.anthropic.claude-3-5-sonnet-20241022-v2:0"
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    },
    {
      name                        = "claude-3-7-sonnet-profile"
      description                 = "Claude 3.7 Sonnet Inference Profile"
      source_inference_model_name = "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
      tags = {
        "Unit" = "Cloud Operations Centre"
      }
    }
  ]
}

# Outputs
output "profile_arns" {
  description = "ARNs of created Bedrock inference profiles"
  value       = module.bedrock.profile_arns
}

output "guardrail_arns" {
  description = "ARNs of created Bedrock guardrails"
  value       = module.bedrock.guardrail_arns
}

output "guardrail_versions" {
  description = "Versions of created Bedrock guardrails"
  value       = module.bedrock.guardrail_versions
}
```

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 0.13.0 |
| AWS Provider | 6.0.0-beta1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `budget_email` | Email address to send budget alerts | `string` | n/a | yes |
| `budget` | Monthly budget for AI resources in USD | `number` | n/a | yes |
| `guardrails` | List of guardrail configurations | `list(object({...}))` | `[]` | no |
| `profiles` | List of inference profile configurations | `list(object({...}))` | `[]` | no |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| `profile_arns` | List of created Bedrock inference profile ARNs | `list(string)` |
| `guardrail_arns` | List of created Bedrock guardrail ARNs | `list(string)` |
| `guardrail_versions` | Versions of created Bedrock guardrails | `list(string)` |

<!--- END_TF_DOCS --->

### Guardrails Configuration
| Field | Description | Type | 
|-------|-------------|------|
| `name` | Name of the guardrail | `string` |
| `description` | Description of the guardrail | `string` |
| `filter_strength` | Strength of content filtering (e.g., LOW, MEDIUM, HIGH) | `string` |
| `filters` | Types of content to filter | `list(string)` |
| `tags` | Optional tags for the guardrail | `map(string)` |

### Profiles Configuration
| Field | Description | Type | 
|-------|-------------|------|
| `name` | Name of the inference profile | `string` |
| `description` | Description of the profile | `string` |
| `source_inference_model_name` | ARN or name of the source model | `string` |
| `tags` | Optional tags for the profile | `map(string)` |

## Best Practices
1. Use comprehensive guardrails to ensure content safety
2. Configure multiple inference profiles for flexibility
3. Set appropriate budget alerts
4. Use tags for better resource management and tracking
5. Regularly review and update model configurations

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-bedrock/blob/master/LICENSE) for full details.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.

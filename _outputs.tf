output "profile_arns" {
  value = { for profile in aws_bedrock_inference_profile.main : profile.name => profile.arn }
}

output "guardrail_arns" {
  value = { for guardrail in aws_bedrock_guardrail.main : guardrail.name => guardrail.guardrail_arn }
}

output "guardrail_versions" {
  value = { for guardrail in aws_bedrock_guardrail_version.main : guardrail.guardrail_arn => guardrail.version }
}

output "profile_arns" {
  value = { for profile in aws_bedrock_inference_profile.main : profile.name => profile.arn }
}

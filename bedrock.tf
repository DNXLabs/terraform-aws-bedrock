resource "aws_bedrock_inference_profile" "main" {
  for_each    = { for profile in var.profiles : profile.name => profile }
  name        = each.value.name
  description = each.value.description

  model_source {
    copy_from = (
      try(each.value.source_foundation_model_name, null) != null
      ?
      "arn:aws:bedrock:${data.aws_region.current.region}::foundation-model/${each.value.source_foundation_model_name}"
      :
      "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:inference-profile/${each.value.source_inference_model_name}"
    )
  }

  tags = merge(
    {
      "Name" = each.value.name
    },
    each.value.tags != null ? each.value.tags : {}
  )
}

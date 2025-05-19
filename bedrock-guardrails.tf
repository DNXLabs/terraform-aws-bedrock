locals {
  guardrail_all_filters = ["SEXUAL", "VIOLENCE", "HATE", "INSULTS", "MISCONDUCT", "PROMPT_ATTACK"]
}

resource "aws_bedrock_guardrail" "main" {
  for_each                  = { for guardrail in var.guardrails : guardrail.name => guardrail }
  name                      = each.value.name
  blocked_input_messaging   = "Sorry, the model cannot answer this question."
  blocked_outputs_messaging = "Sorry, the model cannot answer this question."
  description               = each.value.description

  content_policy_config {
    dynamic "filters_config" {
      for_each = [for filter in try(each.value.filters, local.guardrail_all_filters) : filter]
      content {
        input_strength  = filters_config.value == "PROMPT_ATTACK" ? "NONE" : try(each.value.filter_strength, "HIGH")
        output_strength = filters_config.value == "PROMPT_ATTACK" ? "NONE" : try(each.value.filter_strength, "HIGH")
        type            = filters_config.value
      }
    }
  }

  tags = merge(
    {
      "Name" = each.value.name
    },
    each.value.tags != null ? each.value.tags : {}
  )

  # NOT YET IMPLEMENTED
  # sensitive_information_policy_config {
  #   dynamic "pii_entities_config" {
  #     for_each = try(each.value.pii_action, "") != "" ? [each.value.pii_action] : []
  #     content {
  #       action = each.value.pii_action
  #       type   = "NAME"
  #     }
  #   }

  #   regexes_config {
  #     action      = "BLOCK"
  #     description = "example regex"
  #     name        = "regex_example"
  #     pattern     = "^\\d{3}-\\d{2}-\\d{4}$"
  #   }
  # }

  # topic_policy_config {
  #   topics_config {
  #     name       = "investment_topic"
  #     examples   = ["Where should I invest my money ?"]
  #     type       = "DENY"
  #     definition = "Investment advice refers to inquiries, guidance, or recommendations regarding the management or allocation of funds or assets with the goal of generating returns ."
  #   }
  # }

  # word_policy_config {
  #   managed_word_lists_config {
  #     type = "PROFANITY"
  #   }
  #   words_config {
  #     text = "HATE"
  #   }
  # }
}

resource "aws_bedrock_guardrail_version" "main" {
  for_each      = { for guardrail in var.guardrails : guardrail.name => guardrail }
  description   = each.value.description
  guardrail_arn = aws_bedrock_guardrail.main[each.key].guardrail_arn
}

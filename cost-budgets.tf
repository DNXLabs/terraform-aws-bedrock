resource "aws_budgets_budget" "profile_usage" {
  count = var.budget != 0 ? 1 : 0

  name_prefix  = "bedrock-budget-"
  budget_type  = "COST"
  limit_unit   = "USD"
  limit_amount = var.budget
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Bedrock"]
  }

  cost_types {
    # Getting the real cost of the service
    include_credit             = false
    include_discount           = false
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = true
  }

  dynamic "notification" {
    for_each = var.budget_email != "" ? [1] : []
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = 100
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = [var.budget_email]
    }
  }
}

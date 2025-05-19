resource "aws_bedrock_model_invocation_logging_configuration" "main" {
  count = var.log_enabled ? 1 : 0
  logging_config {
    embedding_data_delivery_enabled = var.log_embedding_data_delivery
    image_data_delivery_enabled     = var.log_image_data_delivery
    text_data_delivery_enabled      = var.log_text_data_delivery
    video_data_delivery_enabled     = var.log_video_data_delivery
    cloudwatch_config {
      log_group_name = aws_cloudwatch_log_group.main[0].name
      role_arn       = aws_iam_role.bedrock_logging_role.arn
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  count = var.log_enabled ? 1 : 0
  name  = var.log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "main" {
  count          = var.log_enabled ? 1 : 0
  name           = "${var.log_group_name}-usage"
  log_group_name = aws_cloudwatch_log_group.main[0].name
  pattern        = "{ $.schemaType = \"ModelInvocationLog\" }"

  metric_transformation {
    name      = "bedrock-invocation"
    namespace = "bedrock"
    value     = 1
    dimensions = {
      "ModelId" = "$.modelId"
      "User"    = "$.identity.arn"
    }
  }
}
data "aws_iam_policy_document" "bedrock_logging_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "bedrock_logging_role" {
  name               = "bedrock-logging-role-${data.aws_region.current.region}"
  assume_role_policy = data.aws_iam_policy_document.bedrock_logging_assume_role_policy.json
}

resource "aws_iam_role_policy" "bedrock_logging_policy" {
  name   = "bedrock-logging-policy"
  role   = aws_iam_role.bedrock_logging_role.id
  policy = data.aws_iam_policy_document.bedrock_logging_policy.json
}

data "aws_iam_policy_document" "bedrock_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.main[0].arn,
      "${aws_cloudwatch_log_group.main[0].arn}:*",
    ]
  }
}

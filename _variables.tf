variable "profiles" {
  description = "List of Bedrock Inference Profiles"
  type = list(object({
    name                         = string
    description                  = string
    source_foundation_model_name = optional(string)
    source_inference_model_name  = optional(string)
    tags                         = optional(map(string))
  }))
  default = []
}

variable "budget_email" {
  description = "Email address to send budget alerts to, leave empty to disable budget alerts"
  type        = string
  default     = ""
}

variable "budget" {
  description = "Budget amount in USD (0 to disable)"
  type        = number
  default     = 0
}

variable "guardrails" {
  description = "Enable guardrails"
  type = list(object({
    name            = string
    description     = string
    filters         = optional(list(string)) # default: ["SEXUAL", "VIOLENCE", "HATE", "INSULTS", "MISCONDUCT", "PROMPT_ATTACK"]
    filter_strength = optional(string)       # default: "HIGH"
    tags            = optional(map(string))
  }))
  default = []
}

# variable "routers" {
#   description = "List of Bedrock Routers"
#   type = list(object({
#     name               = string
#     model_arn          = string
#     model_fallback_arn = string
#     quality_difference = number
#   }))
#   default = []
# }

variable "log_enabled" {
  description = "Enable cloudwatch logging"
  type        = bool
  default     = true
}
variable "log_embedding_data_delivery" {
  description = "Enable embedding data delivery"
  type        = bool
  default     = false
}
variable "log_image_data_delivery" {
  description = "Enable image data delivery"
  type        = bool
  default     = false
}
variable "log_text_data_delivery" {
  description = "Enable text data delivery"
  type        = bool
  default     = false
}
variable "log_video_data_delivery" {
  description = "Enable video data delivery"
  type        = bool
  default     = false
}
variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = "bedrock-logs"
}

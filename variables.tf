# Lambda
variable "region" {
  description = "where you are creating the Lambda, ap-south-1."
  type        = string
}

variable "role_arn" {
  description = "role_arn for resource creation."
  type        = string
}

variable "name" {
  description = "Unique name for your Lambda Function."
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime."
  type        = string
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}


# sqs
variable "que_name" {
  type        = string
  description = "queue_name"
}
variable "visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
}
variable "delay_seconds" {
  type        = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed.An integer from 0 to 900,default 0"
}
variable "max_message_size" {
  type        = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this attribute is 262144 (256 KiB)"
}
variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days"
}
variable "receive_wait_time_seconds" {
  type        = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds), default is 0"
}
variable "fifo_queue" {
  type        = bool
  description = "Whether SQS is FIFO or not"
}
variable "fifo_throughput_limit" {
  type        = string
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are perQueue (default) and perMessageGroupId"
}
variable "kms_master_key_id" {
  type        = string
  description = "KMS key ARN for the SQS."
}
variable "kms_data_key_reuse_period_seconds" {
  type        = number
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again"
}
variable "deduplication_scope" {
  type        = string
  description = "Specifies whether message deduplication occurs at the message group or queue level"
}

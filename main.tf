# Lambda execution role resource
resource "aws_iam_role" "lambda_role" {
  name               = "${var.name}-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}

# Lambda execution role policy resource
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.name}-iam-policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [

       "sqs:ReceiveMessage",
       "sqs:DeleteMessage",
       "sqs:GetQueueAttributes"
       
     ],
     "Resource": ["arn:aws:sqs:*"],
     "Effect": "Allow"
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}

# Lambda execution role policy attachment resource
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Lambda archive_file resource
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

#  Lambda function resource
resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  memory_size   = var.memory_size
  timeout       = var.timeout
  lifecycle {
    ignore_changes = [tags]
  }
}

# SQS
resource "aws_sqs_queue" "terraform_queue" {
  name                              = var.que_name
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  delay_seconds                     = var.delay_seconds
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_queue ? var.fifo_throughput_limit : null
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  deduplication_scope               = var.fifo_queue ? var.deduplication_scope : null

  lifecycle {
    ignore_changes = [tags]
  }
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.terraform_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.terraform_lambda_func.arn
  batch_size       = 1
}
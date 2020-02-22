provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy" "policy" {
  name = "test_policy"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "arn:aws:logs:*:*:*"
    },
    {
      "Effect" : "Allow",
      "Action" : "ec2:*",
      "Resource" : "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_role"
  assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : {
        "Effect" : "Allow",
        "Principal" : {"Service" : "lambda.amazonaws.com"},
        "Action" : "sts:AssumeRole"
      }
}
  EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role = "aws_iam_role.lambda_exec_role.name"
  policy_arn = "aws_iam_policy.policy.arn"
}

resource "aws_lambda_function" "launch_instance" {
  role = "aws_iam_role.lambda_exec_role.arn"
  #role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "launch_instance.lambda_handler"
  runtime = "python3.6"
  filename = "launch_instance.py.zip"
  function_name = "myLaunch"
}

resource "aws_lambda_function" "terminate_instance" {
  role = "aws_iam_role.lambda_exec_role.arn"
  #role = "arn:aws:iam::620636132257:role/lambda_role"
  handler = "terminate_instance.lambda_handler"
  runtime = "python3.6"
  filename = "terminate_instance.py.zip"
  function_name = "myTerminate"
}

resource "aws_cloudwatch_event_rule" "cron_launch" {
  name = "cron_launch"
  schedule_expression = "cron(5 18 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_rule" "cron_terminate" {
  name = "cron_terminate"
  schedule_expression = "cron(5 21 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "run_launch_lambda" {
  rule = "aws_cloudwatch_event_rule.cron_launch.name"
  target_id = "aws_lambda_function.launch_instance.id"
  arn = "aws_lambda_function.launch_instance.arn"
}

resource "aws_cloudwatch_event_target" "run_terminate_lambda" {
  rule = "aws_cloudwatch_event_rule.cron_terminate.name"
  target_id = "aws_lambda_function.terminate_instance.id"
  arn = "aws_lambda_function.terminate_instance.arn"
}
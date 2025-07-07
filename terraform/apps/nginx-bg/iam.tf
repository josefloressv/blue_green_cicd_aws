#region Task Execution role
# The IAM role allows that grants the Amazon ECS container agent permission

resource "aws_iam_role" "exec" {
  name               = "${local.name_prefix}-exec"
  description        = "The task execution role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_trust.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "exec" {
  role       = aws_iam_role.exec.name
  policy_arn = aws_iam_policy.exec.arn
}

resource "aws_iam_policy" "exec" {
  name   = "${local.name_prefix}-exec-policy"
  policy = data.aws_iam_policy_document.exec.json
  tags   = local.common_tags
}

data "aws_iam_policy_document" "exec" {
  statement {
    sid    = "OnlyWildcardSupported"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
  statement {
    sid     = "RetrieveSSMParameters"
    effect  = "Allow"
    actions = ["ssm:GetParameters"]
    resources = [
      "arn:aws:ssm:us-east-1:${local.aws_account_id}:parameter${local.ssm_prefix}/*"
    ]
  }
  statement {
    sid     = "RetrieveSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:us-east-1:${local.aws_account_id}:secret:/secrets/${var.environment}/*"
    ]
  }
  statement {
    sid    = "ECRPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecs:TagResource",
    ]
    resources = [
      "arn:aws:ecr:us-east-1:${local.aws_account_id}:repository/${local.name_prefix}*",
    ]
  }
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:us-east-1:${local.aws_account_id}:log-group:${aws_cloudwatch_log_group.main.name}",
      "arn:aws:logs:us-east-1:${local.aws_account_id}:log-group:${aws_cloudwatch_log_group.main.name}*:log-stream:*",
    ]
  }
}

# Trusted policy
data "aws_iam_policy_document" "ecs_task_execution_trust" {
  # Allow the ECS task to assume the role of the ECS service.
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
#endregion

#region Task role used by the application
resource "aws_iam_role" "task" {
  name               = "${local.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_task.json
  tags = {
    Name        = "${local.name_prefix}-task-role"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "assume_role_policy_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task" {

  statement {
    sid     = "RetrieveSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:us-east-1:${local.aws_account_id}:secret:/secrets/${var.environment}/*"
    ]
  }

}
resource "aws_iam_policy" "task" {
  name   = "${local.name_prefix}-task-policy"
  policy = data.aws_iam_policy_document.task.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment_task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task.arn
}
#endregion
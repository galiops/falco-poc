data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "falco_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.ap-southeast-1.amazonaws.com/id/${var.oidc_id}:sub"
      values   = ["system:serviceaccount:${var.falco_namespace}:${var.falco_serviceaccount}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}"]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "falco_secret" {
  statement {
    sid = "ReadAccessToCloudWatchLogs"
    actions = [
      "logs:Describe*",
      "logs:FilterLogEvents",
      "logs:Get*",
      "logs:List*"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/eks/${var.cluster_name}/cluster:*"]
  }
}

resource "aws_iam_role" "falco_secret" {
  assume_role_policy = data.aws_iam_policy_document.falco_assume_role.json
  name               = "system-galireview-falco-role"
}

resource "aws_iam_role_policy" "falco_secret" {
  name   = "system-galireview-falco-manager-policy"
  role   = aws_iam_role.falco_secret.name
  policy = data.aws_iam_policy_document.falco_secret.json
}

data "aws_iam_policy_document" "trust" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider_arn}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "s3_readonly" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.s3_readonly.arn
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

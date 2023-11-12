provider "aws" {
  profile = "jon@jonsully1.dev"
  region  = "eu-west-2"
}

resource "aws_iam_user" "user" {
  for_each = var.users
  name     = each.key
}

resource "aws_iam_policy" "policy" {
  for_each = var.users
  name     = each.value
  policy   = file("${path.module}/policies/${each.value}.json")
}

resource "aws_iam_user_policy_attachment" "my_user_policy_attachment" {
  for_each   = var.users
  user       = aws_iam_user.user[each.key].name
  policy_arn = aws_iam_policy.policy[each.key].arn
}

resource "aws_iam_access_key" "access_key" {
  for_each = var.users
  user     = aws_iam_user.user[each.key].name
}

resource "aws_secretsmanager_secret" "secret" {
  for_each = var.users
  name     = aws_iam_user.user[each.key].name
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  for_each     = var.users
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.access_key[each.key].id
    secret_key = aws_iam_access_key.access_key[each.key].secret
  })
}
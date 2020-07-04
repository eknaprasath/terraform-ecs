    

resource "aws_iam_role" "role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

  resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.role.name}"]
  # policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  policy_arn = var.iampolicy
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test-role"
  role = aws_iam_role.role.name
}
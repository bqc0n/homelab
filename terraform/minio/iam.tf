resource "minio_iam_policy" "read_write" {
  name = "read-write"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
EOF
}

resource "minio_iam_user" "cloudnative_pg" {
  name = "cloudnative-pg"
}

resource "minio_accesskey" "cloudnative_pg" {
  user = minio_iam_user.cloudnative_pg.name
}

resource "minio_iam_user_policy_attachment" "cloudnative_pg" {
  policy_name = minio_iam_policy.read_write.name
  user_name   = minio_iam_user.cloudnative_pg.name
}
# launch_terminate
Terraform files for AWS configuration

Terraform code to start and stop EC2 instance

Note that in some version there might be a slight difference in terms of syntax. see example below:

role = "aws_iam_role.lambda_exec_role.name" vs role = "${aws_iam_role.lambda_exec_role.name}"

So please modify accordingly.

Please read the comments inside each file and modify accordingly.

When you clone this repo, don't forget to zip the python file before running terraform apply.

Also, one more thing to note: certain terraform versions might cause you to encounter error for i_am_role_policy resource. If that happens to you, please try to downgrade your terraform version.

for reference : https://github.com/terraform-providers/terraform-provider-aws/issues/9918 

This code is written for CIT481 Senior Design - Storage Solution group.

-Petra Antyanti Larisa Anggraeni

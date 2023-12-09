# resource "aws_codedeploy_app" "demo" {
#   compute_platform = "Server"
#   name             = "aws_codedeploy_app Server"
# }

# resource "aws_codedeploy_deployment_group" "example" {
#   app_name              = aws_codedeploy_app.example.name
#   deployment_group_name = "example-group"
#   service_role_arn      = aws_iam_role.example.arn

#   ec2_tag_set {
#     ec2_tag_filter {
#       key   = "filterkey1"
#       type  = "KEY_AND_VALUE"
#       value = "filtervalue"
#     }

#     ec2_tag_filter {
#       key   = "filterkey2"
#       type  = "KEY_AND_VALUE"
#       value = "filtervalue"
#     }
#   }

#   trigger_configuration {
#     trigger_events     = ["DeploymentFailure"]
#     trigger_name       = "example-trigger"
#     trigger_target_arn = aws_sns_topic.example.arn
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   alarm_configuration {
#     alarms  = ["my-alarm-name"]
#     enabled = true
#   }

#   outdated_instances_strategy = "UPDATE"

# }
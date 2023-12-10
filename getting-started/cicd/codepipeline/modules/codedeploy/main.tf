resource "aws_codedeploy_app" "demo_codepipeline" {
  compute_platform = "Server"
  name             = "aws_codedeploy_app_demo"
}

resource "aws_codedeploy_deployment_group" "demo_codepipeline" {
  app_name              = aws_codedeploy_app.demo_codepipeline.name
  deployment_group_name = "example-group"
  service_role_arn      = var.service_role_arn

  deployment_config_name = "CodeDeployDefault.OneAtaTime"

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "MyCodePipelineDemo"
    }
  }

  # trigger_configuration {
  #   trigger_events     = ["DeploymentFailure"]
  #   trigger_name       = "example-trigger"
  #   trigger_target_arn = aws_sns_topic.example.arn
  # }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  outdated_instances_strategy = "UPDATE"
}

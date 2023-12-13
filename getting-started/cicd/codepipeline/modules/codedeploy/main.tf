resource "aws_codedeploy_app" "demo_codepipeline" {
  compute_platform = "Server"
  name             = var.codedeploy_app_name
}

resource "aws_codedeploy_deployment_config" "demo_codepipeline" {
  deployment_config_name = var.deployment_config_name

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}


resource "aws_codedeploy_deployment_group" "demo_codepipeline" {
  app_name              = aws_codedeploy_app.demo_codepipeline.name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = var.service_role_arn

  deployment_config_name = aws_codedeploy_deployment_config.demo_codepipeline.id

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = var.ec2_tag_filter_name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  outdated_instances_strategy = "UPDATE"
}

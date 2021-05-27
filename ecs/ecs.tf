resource "aws_ecs_cluster" "turtle-cluster" {
  depends_on = [
    aws_ecr_repository.turtle_ecr_repo
  ]
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.turtle.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "Joel Fogue"
  }
}

resource "aws_ecs_capacity_provider" "turtle" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

# update file container-def-dd, so it's pulling image from ecr
resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"
  container_definitions = file("container-definitions/container-def-dd-1.json")
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "Joel Fogue"
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.turtle-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = 10
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "flowers-petals-dd"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "Joel Fogue"
  }
}
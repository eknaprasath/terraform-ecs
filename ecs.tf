resource "aws_ecs_cluster" "prod-ecs-cluster" {
  name = var.ecs-cluster-name
}

resource "aws_ecs_task_definition" "service" {
  family                = var.task-def-name
  container_definitions = file("task-definitions/service.json")


  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
  #   requires_compatibilities = ["FARGATE"]
}

resource "time_sleep" "wait_120_seconds" {
  depends_on      = [module.asg, aws_lb_listener.front_end]
  create_duration = "120s"
}


resource "aws_ecs_service" "test" {
  depends_on      = [time_sleep.wait_120_seconds]
  name            = var.service-name
  cluster         = "${aws_ecs_cluster.prod-ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.service.arn}"
  desired_count   = 2
  #   launch_type = "FARGATE"
  #   iam_role        = "${aws_iam_role.foo.arn}"
  #   depends_on      = ["aws_iam_role_policy.foo"]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.front_end.arn}"
    container_name   = "first"
    container_port   = 80
  }

  #  load_balancer {
  #     target_group_arn = "${aws_lb_target_group.front_end_1.arn}"
  #     container_name   = "second"
  #     container_port   = 8080
  #   }
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}
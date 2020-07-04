resource "aws_lb_target_group" "front_end" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id
}

resource "aws_lb_target_group" "front_end_1" {
  name     = "tf-example-lb-tg-1"
  port     = 8080
  protocol = "HTTP"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/sample"
    # port                = "${var.target_group_port}"  
  }
  vpc_id = var.vpc-id
}

resource "aws_lb" "front_end" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = ["sg-09fc601bc351ab2b4"]
  security_groups = var.security-groups
  subnets         = var.subnets

  # enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "80"
  protocol          = "HTTP"
  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.front_end.arn}"
  }
}

resource "aws_lb_listener" "front_end_1" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "8080"
  protocol          = "HTTP"

  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.front_end_1.arn}"
  }
}
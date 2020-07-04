module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "service"

  # Launch configuration
  lc_name = "example-lc"

  image_id        = "ami-00129b193dc81bc31"
  instance_type   = "t2.micro"
  security_groups = ["sg-09fc601bc351ab2b4"]
  user_data = "${file("install_apache.sh")}"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "5"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]
# To use existing launch configuration 

# create_lc = false
# launch_configuration = "existing-launch-configuration"


  # Auto scaling group
  asg_name                  = "example-asg"
  vpc_zone_identifier       = ["subnet-0f11758efca941585", "subnet-0e27590add5df3134"]
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 4
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}
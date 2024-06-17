
resource "aws_lb" "glb" {
  load_balancer_type = "gateway"
  name               = "gwlb-test"

  subnet_mapping {
    subnet_id = var.subnet_id
  }
}


resource "aws_lb_target_group" "glb_target_group" {
  name     = "gwlb-test"
  port     = 6081
  protocol = "GENEVE"
  vpc_id   = aws_vpc.test.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}
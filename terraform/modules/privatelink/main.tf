# ── SANDBOX account: NLB pointing to MSK brokers ──────────────
resource "aws_lb" "msk_nlb" {
  name               = "${var.name}-msk-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.sandbox_private_subnet_ids
  tags               = var.tags
}

resource "aws_lb_target_group" "msk_tg" {
  for_each    = toset(var.msk_broker_ports)
  name        = "${var.name}-tg-${each.value}"
  port        = each.value
  protocol    = "TCP"
  vpc_id      = var.sandbox_vpc_id
  target_type = "ip"
  tags        = var.tags
}

resource "aws_lb_listener" "msk_listener" {
  for_each          = toset(var.msk_broker_ports)
  load_balancer_arn = aws_lb.msk_nlb.arn
  port              = each.value
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.msk_tg[each.value].arn
  }
}

resource "aws_lb_target_group_attachment" "msk_broker_attachment" {
  for_each         = { for pair in var.msk_broker_ips_ports : "${pair.ip}-${pair.port}" => pair }
  target_group_arn = aws_lb_target_group.msk_tg[each.value.port].arn
  target_id        = each.value.ip
  port             = each.value.port
}

# ── SANDBOX account: VPC Endpoint Service ─────────────────────
resource "aws_vpc_endpoint_service" "msk_endpoint_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.msk_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.dev_account_id}:root"]
  tags                       = merge(var.tags, { Name = "${var.name}-endpoint-service" })
}

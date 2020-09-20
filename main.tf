resource "aws_security_group" "main" {
  name        = "${var.vpc.tags.Name}_${var.name}"
  vpc_id      = var.vpc.id

  dynamic "ingress" {
    for_each = var.ingresses

    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", [])
      security_groups  = lookup(ingress.value, "security_groups", [])
      self             = lookup(ingress.value, "self", false)
      description      = lookup(ingress.value, "description", "")
    }
  }

  dynamic "egress" {
    for_each = var.egresses

    content {
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      from_port        = egress.value.from_port
      cidr_blocks      = lookup(egress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", [])
      security_groups  = lookup(egress.value, "security_groups", [])
      self             = lookup(egress.value, "self", false)
      description      = lookup(egress.value, "description", "")
    }
  }

  tags = {
    Name = "${var.vpc.tags.Name}_${var.name}"
    vpc  = var.vpc.tags.Name
  }
}

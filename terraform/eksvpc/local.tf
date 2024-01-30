locals {
  tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    ENV                                         = "${var.env}"
  }
  tag2name = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    ENV                                         = "${var.env}"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.myapp-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.myapp-cluster-auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = "myapp-eks-cluster"
}

data "aws_eks_cluster_auth" "myapp-cluster-auth" {
  name = "myapp-eks-cluster" #module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "${var.app_name}-eks-cluster"
  cluster_version = "1.27"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id     = module.myapp-vpc.vpc_id

  tags = {
    environment = var.environment
    application = var.app_name
  }

  self_managed_node_groups = {

    default_node_group = {}
  }
}
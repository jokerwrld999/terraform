provider "kubernetes" {
  host                   = data.aws_eks_cluster.myapp-cluster.id
  token                  = data.aws_eks_cluster_auth.myapp-cluster-auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster-auth" {
  name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.27"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id     = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

  self_managed_node_groups = {

    worker_group = {
      instance_type        = "t2.micro"
      name                 = "worker-group-1"
      asg_desired_capacity = 3
    }
  }
}
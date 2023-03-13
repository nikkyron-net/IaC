# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
     }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.5.1"
      version = "~> 2.5"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      version = "~> 2.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }     
  }
  # Adding Backend as S3 for Remote State Storage
  /*cloud {
    organization = "upmyjob-com"

    workspaces {
      name = "EKS"
    }
  } */
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}
#provider "http" {
  # Configuration options
#}
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
provider "kubernetes" {
  host = aws_eks_cluster.eks_cluster.endpoint 
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}
provider "kubectl" {
  # Configuration options
  host = aws_eks_cluster.eks_cluster.endpoint 
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}
provider "kustomization" {
  kubeconfig_raw = module.eks-kubeconfig.kubeconfig
}

# Datasource: EKS Cluster Auth 
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.id
}

# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Business Division
variable "department" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "upmyjob"
}

# Define Local Values in Terraform
locals {
  name = "${var.department}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    department = var.department
    environment = var.environment
  }
} 

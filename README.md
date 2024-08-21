# Awake Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.
Creates VPC with 6 subnets (3 public, 3 private), route tables, Security Groups for cluster and nodes
Includes roles to perform all EKS tasks.

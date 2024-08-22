# Awake Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.
Creates VPC with 6 subnets (3 public, 3 private), route tables, Security Groups for cluster and nodes
Includes roles to perform all EKS tasks.
Once created a policy to view nodes and pods is necessary which can be created in the AWS Console follow the prompts and add Admin access.
Note when destroying this configuration the load balancer needs to be manually deleted because the script does not contain the load balancer in it but it gets created. If not deleted the eni will block the destroy operation by remaining attached to subnet and eni.
If re installing take note that the Jenkins application needs to use the upgrade option or uninstall and re install. It will not allow you to install to the same location twice.
if pods are not visible from user in EC2 then do the following
sudo chmod 644 /var/lib/jenkins/workspace/mandarin/.kube/config
sudo chown jenkins:jenkins /var/lib/jenkins/workspace/mandarin/.kube/config
sudo chmod 755 /usr/local/bin/kubectl
export KUBECONFIG=/var/lib/jenkins/workspace/mandarin/.kube/config

kubectl get pods -n mandarin --kubeconfig /var/lib/jenkins/workspace/mandarin/.kube/config



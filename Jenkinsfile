pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'eu-west-1'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/CT-Software-Engineering/awake.git']])
                }
            }
        }

        stage('Initializing Terraform') {
            steps {
                script {
                    dir('awake') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Formatting Terraform Code') {
            steps {
                script {
                    dir('awake') {
                        sh 'terraform fmt -recursive'
                    }
                }
            }
        }

        stage('Validating Terraform') {
            steps {
                script {
                    dir('awake') {
                        sh 'terraform validate'
                    }
                }
            }
        }

        stage('Previewing the Infrastructure') {
            steps {
                script {
                    dir('awake') {
                        sh 'terraform plan'
                        // input(message: "Are you sure to proceed?", ok: "proceed")
                    }
                }
            }
        }

        stage('Creating/Destroying an EKS Cluster') {
            steps {
                script {
                    dir('awake') {
                        // sh 'terraform $action --auto-approve'
                        sh 'terraform apply --auto-approve'
                        //sh 'terraform destroy --auto-approve'
                    }
                }
            }
        }

        stage('Initializing Helm') {
            steps {
                script {
                    sh 'helm repo add bitnami https://charts.bitnami.com/bitnami'
                    sh 'helm repo update'
                }
            }
        }

        stage('Update Kubeconfig') {
            steps {
                script {
                    sh 'aws eks update-kubeconfig --name mandarin --kubeconfig "/var/lib/jenkins/workspace/mandarin/.kube/config"'
                }
            }
        }

        stage('Deploying Jenkins') {
            steps {
                script {
                    sh 'helm upgrade jenkins bitnami/jenkins --namespace mandarin --create-namespace --kubeconfig "/var/lib/jenkins/workspace/mandarin/.kube/config"'
                    //sh 'helm install jenkins bitnami/jenkins --namespace mandarin --create-namespace --kubeconfig "/var/lib/jenkins/workspace/mandarin/.kube/config"'
                    //sh 'helm uninstall jenkins bitnami/jenkins --namespace mandarin --create-namespace --kubeconfig "/var/lib/jenkins/workspace/mandarin/.kube/config"'
                    
                }
            }
        }

        stage('Verify Jenkins Deployment') {
            steps {
                script {
                    sh 'kubectl get pods -n mandarin --kubeconfig "$KUBECONFIG"'
                    sh 'kubectl get svc -n mandarin --kubeconfig "$KUBECONFIG"'
                }
            }
        }

        stage('Deploying NGINX') {
            steps {
                script {
                    dir('awake/configuration-files') {
                        withCredentials([string(credentialsId: 'AWS_EKS_CLUSTER_NAME', variable: 'CLUSTER_NAME')]) {
                            // Add debug output to check cluster name
                            echo "Cluster Name: \$CLUSTER_NAME"
                            // Check if the cluster exists
                            sh 'aws eks describe-cluster --name $CLUSTER_NAME --region ${AWS_DEFAULT_REGION}'
                            sh 'aws eks update-kubeconfig --name $CLUSTER_NAME --kubeconfig "$KUBECONFIG"'
                            sh 'kubectl apply -f deployment.yml --kubeconfig "$KUBECONFIG" --validate=false'
                            sh 'kubectl apply -f service.yml --kubeconfig "$KUBECONFIG" --validate=false'
                        }
                    }
                }
            }
        }
    } // End of stages

} // End of pipeline

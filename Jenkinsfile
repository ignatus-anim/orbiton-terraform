pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-1'
        PROJECT_NAME = 'orbiton'
        ENVIRONMENT = 'dev'
        DOCKER_IMAGE = 'ignatusa3/nextjs-frontend:133c6a3e7e4ff8ce161d95257979e23abf286e68'
        CONTAINER_PORT = '3000'
        TERRAFORM_DIR = 'environments/dev'
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select the Terraform action to perform'
        )
        choice(
            name: 'DEPLOY_APP',
            choices: ['yes', 'no'],
            description: 'Deploy application after infrastructure creation?'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('AWS Credentials') {
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir(TERRAFORM_DIR) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                            terraform init \
                                -backend-config="bucket=orbiton-terraform-state" \
                                -backend-config="key=${ENVIRONMENT}/terraform.tfstate" \
                                -backend-config="region=${AWS_REGION}" \
                                -backend-config="dynamodb_table=orbiton-terraform-locks" \
                                -backend-config="encrypt=true"

                            terraform validate
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'plan' || params.ACTION == 'apply' }
            }
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir(TERRAFORM_DIR) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform plan -var-file="terraform.tfvars" -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir(TERRAFORM_DIR) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir(TERRAFORM_DIR) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform destroy -var-file="terraform.tfvars" -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Deploy Application') {
            when {
                expression { params.ACTION == 'apply' && params.DEPLOY_APP == 'yes' }
            }
            steps {
                withCredentials([
                    aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        sh """
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            
                            aws eks update-kubeconfig \
                                --region ${AWS_REGION} \
                                --name ${PROJECT_NAME}-${ENVIRONMENT}-eks

                            kubectl apply -f kubernetes/deployment.yaml
                            kubectl rollout status deployment/tiny-node-app

                            echo "Waiting for LoadBalancer to be ready..."
                            sleep 30
                            kubectl get service tiny-node-app-service

                            echo "EC2 Instance Details:"
                            aws ec2 describe-instances \
                                --region ${AWS_REGION} \
                                --filters "Name=tag:Name,Values=${PROJECT_NAME}-${ENVIRONMENT}-ec2" \
                                --query 'Reservations[].Instances[].PublicDnsName' \
                                --output text
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Please check the logs for details.'
        }
    }
}

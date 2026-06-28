pipeline {
    agent any

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS Region to deploy the EC2 instance')
        string(name: 'AMI_ID', description: 'The AMI ID for the EC2 instance (e.g., ami-0c55b159cbfafe1f0)')
        choice(name: 'INSTANCE_TYPE', choices: ['t2.micro', 't2.small', 't3.micro', 't3.small'], description: 'EC2 Instance Type')
    }

    environment {
        // Binds the AWS Credentials helper. Jenkins automatically populates 
        // AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY when using this credential type.
        AWS_CREDS = credentials('aws_credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                // In a real SCM setup, this checkout is automatic. 
                // We add a clean step to ensure a pristine workspace.
                cleanWs()
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                    terraform plan \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="ami_id=${params.AMI_ID}" \
                    -var="instance_type=${params.INSTANCE_TYPE}"
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                sh """
                    terraform apply -auto-approve \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="ami_id=${params.AMI_ID}" \
                    -var="instance_type=${params.INSTANCE_TYPE}"
                """
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

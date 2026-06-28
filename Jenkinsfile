pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Action to perform on the infrastructure')
        string(name: 'INSTANCE_NAME', defaultValue: 'ec2-instance-1', description: 'A unique name for this instance (defines the Terraform workspace)')
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
                // We do NOT use cleanWs() here anymore to preserve local state files 
                // if you are not using a remote S3 backend yet.
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh """
                    terraform workspace select ${params.INSTANCE_NAME} || terraform workspace new ${params.INSTANCE_NAME}
                    terraform plan \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="ami_id=${params.AMI_ID}" \
                    -var="instance_type=${params.INSTANCE_TYPE}" \
                    -var="instance_name=${params.INSTANCE_NAME}"
                """
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh """
                    terraform workspace select ${params.INSTANCE_NAME}
                    terraform apply -auto-approve \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="ami_id=${params.AMI_ID}" \
                    -var="instance_type=${params.INSTANCE_TYPE}" \
                    -var="instance_name=${params.INSTANCE_NAME}"
                """
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                sh """
                    terraform workspace select ${params.INSTANCE_NAME}
                    terraform destroy -auto-approve \
                    -var="aws_region=${params.AWS_REGION}" \
                    -var="ami_id=${params.AMI_ID}" \
                    -var="instance_type=${params.INSTANCE_TYPE}" \
                    -var="instance_name=${params.INSTANCE_NAME}"
                """
            }
        }
    }
}

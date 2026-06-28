# Parameterized Jenkins Pipeline for AWS EC2 Provisioning using Terraform

This repository contains the Terraform configurations and Jenkins Pipeline script (`Jenkinsfile`) required to dynamically provision or destroy an AWS EC2 instance using Jenkins parameters.

## Project Structure

*   **[Jenkinsfile](file:///c:/Users/Prashanth/jenkins-terraform/Jenkinsfile)**: The Jenkins declarative pipeline containing stages to initialize, plan, apply, or destroy the infrastructure based on user parameters.
*   **[main.tf](file:///c:/Users/Prashanth/jenkins-terraform/main.tf)**: Defines the AWS EC2 instance resource and the outputs (Public IP and Instance ID).
*   **[providers.tf](file:///c:/Users/Prashanth/jenkins-terraform/providers.tf)**: Configures the HashiCorp AWS provider dynamically.
*   **[variables.tf](file:///c:/Users/Prashanth/jenkins-terraform/variables.tf)**: Declares the input variables required by the Terraform configuration.

---

## Prerequisites

Before running the pipeline, ensure the following are set up:

1.  **Jenkins Server Configuration**:
    *   **Terraform CLI** must be installed on the Jenkins controller or the agent executing the job, and its path must be available in the system `PATH`.
    *   The **Credentials Binding Plugin** must be installed in Jenkins.
2.  **AWS Credentials**:
    *   An AWS IAM User with programmatic access (Access Key ID and Secret Access Key) and sufficient permissions to manage EC2 instances.
    *   Add these credentials in Jenkins (**Manage Jenkins** > **Credentials**) with the ID **`aws_credentials`** (choose the **AWS Credentials** type).

---

## Jenkins Pipeline Parameters

When triggering the pipeline via **Build with Parameters**, you will be prompted to provide the following inputs:

| Parameter | Type | Description |
| :--- | :--- | :--- |
| **`ACTION`** | Choice | `apply` to deploy/update the EC2 instance, or `destroy` to terminate the EC2 instance. |
| **`AWS_REGION`** | String | The AWS Region to deploy the infrastructure in (default: `us-east-1`). |
| **`AMI_ID`** | String | The Amazon Machine Image (AMI) ID for the EC2 instance (e.g., `ami-0c55b159cbfafe1f0`). |
| **`INSTANCE_TYPE`** | Choice | The size of the EC2 instance (options: `t2.micro`, `t2.small`, `t3.micro`, `t3.small`). |

---

## How it Works

1.  **Initialization**:
    *   The pipeline checks out the repository and runs `terraform init` to download the AWS provider.
2.  **Conditional Execution**:
    *   If **`ACTION`** is set to `apply`, the pipeline executes the **Terraform Plan** and **Terraform Apply** stages to provision the instance.
    *   If **`ACTION`** is set to `destroy`, the pipeline skips planning and directly executes the **Terraform Destroy** stage to terminate the instance.
3.  **State Management**:
    *   By default, this project uses local state. For production environments, it is highly recommended to configure a remote backend (e.g., AWS S3 and DynamoDB) in `providers.tf`.

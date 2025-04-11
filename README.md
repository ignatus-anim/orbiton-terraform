# Orbiton Infrastructure Project

This project manages AWS infrastructure using Terraform, including VPC, EC2, EKS cluster, and application deployment through Jenkins pipeline.

## Project Overview

The infrastructure includes:
- VPC with public and private subnets
- EC2 instance running Ubuntu 22.04
- EKS cluster with managed node groups
- Node.js application deployment on EKS
- Jenkins pipeline for infrastructure automation

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform (v1.11.3 or later)
- Jenkins installed locally
- kubectl
- Docker

## Project Structure

```
.
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── modules/
│   ├── ec2/
│   ├── eks/
│   ├── security_group/
│   └── vpc/
├── kubernetes/
│   └── deployment.yaml
├── scripts/
│   ├── deploy.sh
│   ├── deploy-app.sh
│   └── destroy.sh
├── Jenkinsfile
└── .gitignore
```

## Infrastructure Components

### VPC Configuration
- CIDR: 10.0.0.0/16
- Public Subnets: 10.0.1.0/24, 10.0.2.0/24
- Private Subnets: 10.0.3.0/24, 10.0.4.0/24
- Availability Zones: eu-west-1a, eu-west-1b

### EC2 Instance
- Type: t3.micro
- OS: Ubuntu 22.04
- Docker and Nginx pre-installed
- Security group with ports 22, 443, and 4000 open

### EKS Cluster
- Node Group Instance Type: t3.small
- Desired Capacity: 2 nodes
- Min/Max Capacity: 1/3 nodes

### Application
- Docker Image: ignatusa3/tiny-node-app:1.0
- Exposed Port: 4000
- Load Balancer Service Type

## Getting Started

1. **Initial Setup**
```bash
# Clone the repository
git clone <repository-url>
cd orbiton-project

# Make scripts executable
chmod +x scripts/*.sh

# Create initial infrastructure
./scripts/deploy.sh
```

2. **Configure Jenkins**
- Install required plugins:
  - AWS Credentials Plugin
  - Pipeline Plugin
  - Git Plugin
  - Terraform Plugin
- Add AWS credentials in Jenkins
- Create new pipeline using the provided Jenkinsfile

3. **Deploy Infrastructure**
- Use Jenkins pipeline with parameters:
  - ACTION: plan/apply/destroy
  - DEPLOY_APP: yes/no

## Jenkins Pipeline

The pipeline includes stages for:
- Infrastructure provisioning with Terraform
- EKS cluster configuration
- Application deployment
- Infrastructure cleanup

## Available Scripts

- `deploy.sh`: Sets up initial AWS resources (S3, DynamoDB, Key Pair)
- `deploy-app.sh`: Deploys application to EKS cluster
- `destroy.sh`: Cleans up all created resources

## Environment Variables

Key environment variables in Jenkinsfile:
```
AWS_REGION = 'eu-west-1'
PROJECT_NAME = 'orbiton'
ENVIRONMENT = 'dev'
DOCKER_IMAGE = 'ignatusa3/tiny-node-app:1.0'
```

## Terraform State Management

- Backend: AWS S3
- Bucket: orbiton-terraform-state
- DynamoDB Table: orbiton-terraform-locks
- State File Key: dev/terraform.tfstate

## Cleanup

To destroy all resources:
```bash
./scripts/destroy.sh
```

## Security Notes

- EC2 key pair is generated and stored locally
- S3 bucket has versioning enabled
- State file is encrypted at rest
- Security groups are configured with minimal required access

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

[Add your license information here]

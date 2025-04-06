## Features

- Local development with Docker Compose
- Infrastructure provisioning using Terraform
- Simulated AWS services with LocalStack
- CI/CD pipeline with GitHub Actions
- ECS Fargate deployment
- ECR integration via LocalStack

## Environment

- Docker and Docker Compose
- Terraform
- AWS CLI
- Node.js
- LocalStack
- Git

## Local Development Setup

1. Clone the repository:

```bash
git clone https://github.com/HitishRaoP/medusa-terraform.git
cd medusa-terraform
```

2. Start the backend services:

```bash
cd backend
docker-compose up -d
```

**This starts Medusa, Postgres, and Redis. You do not need to run Postgres or Redis separately during local development.**


## GitHub Actions Workflow

The workflow is located in `.github/workflows/deploy.yml`. On every push to the `main` branch, it:

- Builds the Medusa Docker image
- Pushes it to LocalStack's ECR
- Runs Terraform to update the deployment

**Note: During the workflow execution, Postgres and Redis must be available as the backend depends on them.**

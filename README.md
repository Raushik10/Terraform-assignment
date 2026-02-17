
Task 1 – Terraform Basics


Objective:-

To understand and implement basic Terraform concepts by provisioning AWS resources.



Implementation:-

Terraform was used to define and create AWS resources.

Infrastructure was successfully provisioned using terraform init and terraform apply.

Resources were verified via the AWS Management Console.


Outcome:-

Terraform configuration executed successfully.

All defined resources were created and validated.




Task 2 – Intermediate Terraform


Objective:-

To implement intermediate Terraform concepts including resource dependencies, outputs, and service validation.



Implementation:-

Terraform was used to deploy required AWS services.

Proper dependency handling was implemented using Terraform resource references.

Outputs were defined to verify successful provisioning.


Outcome:-

Infrastructure was created successfully.

Services were verified to be running as expected.

Outputs confirmed correct deployment.



Task 3 – ECS with Application Load Balancer (Major Task)
Objective

To deploy a containerized frontend and backend application using Amazon ECS Fargate and expose it using an Application Load Balancer, fully automated with Terraform.



Architecture :-

VPC with multiple subnets across different Availability Zones

Application Load Balancer (ALB)

Target Groups with health checks

ECS Cluster (Fargate)

ECS Task Definitions for:

Frontend (Express)

Backend (Flask)

ECS Services

IAM roles and policies

Amazon ECR for Docker images



Implementation:-

Docker images were built and pushed to Amazon ECR.

ECS Task Definitions referenced images stored in ECR.

ECS Services were integrated with ALB target groups.

Security groups and networking were configured via Terraform.

Entire setup was deployed using a single terraform apply.



Outcome:-

ECS tasks are running successfully.

Target groups show healthy targets.

Application is accessible using the ALB DNS URL.

Frontend and backend communication is functioning correctly.

No manual configuration was required outside Terraform.



Terraform Execution Steps:-

terraform init
terraform plan
terraform apply



Verification:-

Terraform apply completed successfully without errors.

AWS resources verified through AWS Console.

ECS tasks are in RUNNING state.

Application is accessible via the ALB URL.

Key Highlights

Entire infrastructure created using Terraform only

No manual AWS Console configuration

Modular, repeatable, and production-ready setup

Demonstrates real-world ECS + ALB deployment


## Terraform in 15 Minutes, Overview Notes

https://www.youtube.com/watch?v=l5k1ai_GBDE

- What is Terraform?
  - allows you to automate and manage your cloud infrastructure (ex. AWS) and services that run on the infrastructure (Ex. Create, and configure Lambda, AWS S3, …)
    - **Declarative** language = define what end result you want, and terraform will execute
    - **Imperative** language = how to get what you want
  - Can deploy applications
- **Providers** (Ex. AWS, Microsoft Azure, Kubernetes, …)

- Terraform **Core**
  - Where you define what resources need to be created and the state of the application
  - **Core 2 Inputs**
    - **Configuration file ( .tf )**
      - User writes this
      - Define what needs to be created (ex. AWS Lambda function)
      - 1. Define provider (ex AWS)
      - 2. define resource you want (ex. EC2 instance)
    - **State**
      - Current state of setup of infrastructure (ex. There’s only 1 server)
  - Core will then use providers to get from the current state to the desired state/configuration

- Terraform Basic Commands
  - **refresh**
    - Query infrastructure provider to get current state of application
  - **plan**
    - Create an execution plan to get to the desired state (like a preview of what’s going to happen)
  - **apply**
    - Execute the plan
  - **destroy**
    - Deletes the resources/infrastructure

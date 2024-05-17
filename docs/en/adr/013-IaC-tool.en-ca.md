# ADR-013: Management of Infrastructure as Code (IaC)

## Executive Summary

We have decided to adopt Terraform as our Infrastructure as Code (IaC) solution
for managing and deploying our infrastructure across multiple cloud providers.
This decision is based on Terraform's cross-cloud compatibility, our extensive
knowledge of the tool, and its state tracking capabilities. Terraform also
offers broader maturity and community support, without being tied to any
specific cloud provider, and allows the creation of custom extensibility
providers.

## Context

As part of our effort to enhance the efficiency and reproducibility of managing
our cloud infrastructure, we evaluated several IaC tools. Our infrastructure,
while primarily hosted on Azure at present, could expand to other providers in
the future, highlighting the need for a flexible and powerful IaC tool.

Using an IaC tool allows us to benefit from version control of our
infrastructure, similar to what Git provides for source code. This means we can
track, review, and reverse infrastructure changes in a controlled and documented
manner. Additionally, an IaC tool significantly reduces the time required for
provisioning and managing infrastructure, as it allows deploying and updating
infrastructure through configuration files instead of manual procedures. This
approach also ensures a more consistent environment, reducing discrepancies
between development, test, and production environments. Finally, by automating
infrastructure management, we minimize the risk of human errors, thus enhancing
the security and reliability of our systems.

## Decision

After thorough evaluation, we have chosen Terraform as our infrastructure
management tool. This decision is based on several key factors: our existing
experience with this tool, Terraform's cross-cloud compatibility through a
consistent workflow model using a descriptive language, and its state file
functionality that facilitates tracking infrastructure changes. Moreover,
Terraform's maturity and its vast community provide additional assurance
regarding the tool's reliability and scalability. Terraform also allows us to
create custom extensibility providers, a crucial feature for our project that
requires integration with HashiCorp Vault and GitHub. Thus, Terraform enables us
to utilize providers such as Helm, Kubernetes, ArgoCD, Azure DevOps, GitHub,
Ansible, and many others.

## Considered Alternatives

### Bicep

Advantages:

- Native integration with Azure, offering a simplified experience for managing
  Azure resources.
- Simplified syntax compared to older tools like Azure Resource Manager (ARM)
  templates.

Disadvantages:

- No integrated state management: unlike Terraform, which has a state file
  feature that allows tracking and managing changes in infrastructure (if an
  item is removed from the deployment code, Terraform proceeds with its
  destruction), Bicep does not have a similar concept. This means that
  modifications or deletions of items require manual intervention or additional
  logic to manage the state of the infrastructure.
- Primarily limited to the Azure ecosystem, which poses challenges for
  multi-cloud deployments.
- Creation of custom extensibility providers is still in the experimental phase.

### CloudFormation

Advantages:

- Deep integration with the AWS ecosystem, facilitating the management of AWS
  resources.

Disadvantages:

- Confined to the AWS ecosystem, limiting flexibility for multi-cloud
  deployments.
- Less support for custom extensibility compared to Terraform.

### Pulumi

Advantages:

- Familiar Programming Languages: Pulumi allows developers to use
  general-purpose programming languages such as TypeScript, Python, Go, and
  .NET, which can reduce the learning curve and facilitate integration into
  existing CI/CD pipelines.
- Cloud-Managed State: Pulumi manages the infrastructure state in the cloud,
  offering a centralized and secure approach to tracking infrastructure
  deployments.
- Multi-Cloud and On-Premise Support: Pulumi provides broad support for cloud
  providers including Azure, AWS, Google Cloud, as well as on-premise resources,
  offering great flexibility for hybrid and multi-cloud deployments.

Disadvantages:

- Potential complexity: Using full programming languages can introduce
  additional complexity into infrastructure management, especially for teams not
  familiar with these languages.
- Dependency on Pulumi Service: While Pulumi offers options to manage state
  locally or in the cloud, the cloud-managed version creates a dependency on
  Pulumi's services, raising concerns about data sovereignty or additional
  costs.
- Less mature than Terraform: Pulumi is newer to the IaC market than Terraform,
  meaning it might have a smaller community and fewer resources available for
  troubleshooting and learning compared to Terraform.

## Consequences

Adopting Terraform as our primary IaC tool will allow us to unify the management
of our infrastructure across various providers, thus improving efficiency and
reducing the risk of manual errors. This will require ongoing training for our
teams to fully leverage Terraform's capabilities. We also anticipate improved
collaboration among development, operations, and security teams through a
consistent approach to infrastructure management. The decision supports our goal
of agility and security in the development and deployment of our applications,
while promoting the use of open source solutions for greater transparency and
collaboration.

## References

- [Documentation on workflow with Terraform for deploying
our services](../terraform-workflow.md)
- [Infrastructure source code
  (Howard)](https://github.com/ai-cfia/howard/tree/main/terraform)
- [Official Terraform website](https://www.terraform.io/)
- [Bicep
  documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Pulumi Github repository](https://github.com/pulumi/pulumi)
- [AWS CloudFormation user guide](https://docs.aws.amazon.com/cloudformation/)
- [Experimental phase for extensibility providers in
  Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import#import-namespaces-and-extensibility-providers-preview)

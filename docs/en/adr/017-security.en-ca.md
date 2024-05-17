# ADR-017: Security

## Executive Summary

This ADR documents and formalizes the enhancement of our security strategy
through management and monitoring of vulnerabilities within our Kubernetes
infrastructure. We have enhanced our security capabilities by integrating
trivy-operator and Falco for static and dynamic scanning, while also continuing
to use Dependabot for managing code dependencies. Additionally, we have adopted
Mend Renovate to automate updates for Docker images, Terraform providers, and
other dependencies to maintain the usage of the most secure versions. Monitoring
and visualization of these security measures are conducted through
Grafana dashboards.

## Background

Traditionally, our security strategy primarily relied on Dependabot for
security alerts related to our code dependencies. In response to increased
security demands and the need to address vulnerabilities both statically and
dynamically, we expanded our suite of security tools.

## Decision

We have bolstered our security architecture by incorporating the following
tools:

- **Trivy-operator:** Conducts static scanning of our cluster and the container
images of our pods to detect vulnerabilities before deployment.

- **Falco:** Performs dynamic scanning to monitor real-time behavior of
applications and detect any abnormal or suspicious activity.

- **Mend Renovate:** Automates the updates of our Docker images, Terraform
providers, and other dependencies, ensuring the use of the latest and most
secure versions.

These tools are complemented by Grafana dashboards, enabling real-time
visualization and security alert management, facilitating swift and informed
interventions.

## Considered Alternatives

### Snyk

Advantages:

- **Proactive Security:** Snyk offers a proactive security solution by detecting
vulnerabilities in dependencies and containers and proposing automated fixes.

- **Wide Range of Integrations:** Easily integrates with CI/CD tools and hosting
platforms such as GitHub and Bitbucket, enabling automated vulnerability
detection and remediation within the development pipeline.

Disadvantages:

- **Potentially High Cost:** Advanced features of Snyk can be costly,
particularly for large organizations managing numerous environments.

- **Learning and Configuration:** Setting up and optimizing Snyk for specific
environments might require a significant learning curve and configuration time.

### Sysdig Secure

Advantages:

- **Detailed Inspection:** Provides in-depth analysis of real-time network
traffic and file system monitoring.

- **Wide Compatibility:** Works with most cloud environments and container
orchestrators.

Disadvantages:

- **Resource Intensive:** May use a substantial amount of system resources,
affecting performance.

- **Complex Integration:** Although powerful, it can be difficult to integrate
and requires regular maintenance to stay updated with system and orchestrator
updates.

## Conclusion

Integrating trivy-operator, Falco, and Mend Renovate, alongside Dependabot,
significantly strengthens our security strategy, enabling us to proactively and
in real time address vulnerabilities in our Kubernetes infrastructure. This
comprehensive strategy, supported by clear visualization via Grafana, ensures
that we maintain a solid security posture, which is crucial for the reliability
and performance of our services.

## References

- [Falco](https://falco.org/)
- [Trivy](https://www.aquasec.com/products/trivy/)
- [MEND Renovate](https://docs.renovatebot.com/)
- [Dependabot](
https://github.blog/2020-06-01-keep-all-your-packages-up-to-date-with-dependabot/)
- [Snyk](https://snyk.io/fr/)
- [Sysdig secure](https://docs.sysdig.com/en/docs/sysdig-secure/)

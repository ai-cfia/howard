# ADR-014: Containerization

## Executive Summary

The use of containers and Kubernetes has proven effective for the management
and deployment of our applications. This approach provides several benefits,
including portability, which allows containers to run consistently across
different environments, thereby simplifying development and deployment.
Scalability is also a strong point, as Kubernetes enables easy scaling of
applications based on demand. In terms of reliability, containers and
Kubernetes offer improved fault tolerance and high availability. Lastly,
efficiency is enhanced through the use of containers, which optimize
resource utilization and reduce costs.

## Background

Previously, we manually deployed each Dockerfile on Google Cloud Run. This
approach required significant time investment, as each deployment necessitated
manual intervention for building and deploying containers. Despite the
systematic presence of Dockerfiles in our repositories, the process of
development and deployment remained relatively unautomated.

## Decision

To overcome these limitations, we decided to adopt Kubernetes for container
orchestration. This transition allows us to benefit from more robust and
scalable management of our applications. However, deployment is not fully
automated; Kubernetes manifests must be created and then deployed via ArgoCD,
providing an additional level of control and validation before final deployment.

Regarding Docker images, we have set up a GitHub workflow that automates the
process of building, tagging, and uploading. This automation helps ensure the
consistency and reliability of our deployments while reducing manual
workload and error risks.

## Considered Alternatives

### Docker Swarm

Advantages:

- **Native Integration with Docker:** Docker Swarm is tightly integrated with
Docker and uses the Docker API, which makes setup and management simpler
for teams already familiar with Docker.

- **Ease of Deployment:** Docker Swarm is simpler to configure and manage
compared to Kubernetes, which can be beneficial for small to medium
infrastructures without complex needs.

- **Performance:** Docker Swarm often shows better performance in terms of
container startup time and resource usage.

Disadvantages:

- **Limited Scalability:** Docker Swarm is less suited for large clusters than
Kubernetes. Kubernetes excels in managing large, complex clusters.

- **Less Robust Features:** Compared to Kubernetes, Docker Swarm offers fewer
advanced features, such as sophisticated deployment strategies, advanced
volume management, and extensive support for CI/CD tools.

- **Smaller Community:** The community around Docker Swarm is less active than
that of Kubernetes, which can impact support and the development
of new features.

### Nomad

Advantages:

- **Simplicity and Flexibility:** Nomad is known for its simplicity and
flexibility. This makes the orchestrator ideal for both non-containerized
applications and containers.

- **Heterogeneous Resources and Multi-region:** Nomad can manage workloads on
different types of servers, including bare metal, VMs, or containerized
environments, and can easily handle multi-region clusters.

- **High Performance and Efficiency:** Nomad is designed to perform well at
large scales, offering quick task start-ups and minimal overhead.

Disadvantages:

- **Fewer Features than Some Competitors:** Although appreciated for its
simplicity, Nomad may lack some advanced features found in other
orchestrators like Kubernetes.

- **More Limited Ecosystem:** The ecosystem around Nomad is less developed
compared to more mature solutions like Kubernetes. This can result in a more
limited offering in terms of third-party tools, plugins, or integrations,
making some tasks more complex to implement and maintain.

## Conclusion

The adoption of Kubernetes has proven to be a wise decision for the management
and deployment of our containerized applications. This approach has improved
the portability, scalability, reliability, and efficiency of our applications.

## References

- [Kubernetes](https://kubernetes.io/)
- [Docker](https://www.docker.com/)
- [Docker swarm](https://docs.docker.com/engine/swarm/)
- [Nomad](https://www.nomadproject.io/)

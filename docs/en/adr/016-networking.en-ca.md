# ADR-016: Networking

## Executive Summary

This Architectural Decision Record (ADR) is aimed at formalizing the networking
strategy for our applications deployed on Kubernetes, assessing both current
and future network access components to maximize performance, security, and
ease of management. We use Azure for this architecture and integrate Nginx
Ingress, cert-manager, vouch-proxy, and automated DNS record management
through external-dns.

## Background

In our current Kubernetes architecture, we utilize Nginx Ingress for access
control, managed by a static IP assigned by Azure. We automate the creation of
CNAME records for our services via external-dns, which significantly facilitates
DNS management. Additionally, cert-manager is deployed for automatic SSL
certificate management, thereby securing communications, while vouch-proxy
manages secure access to our applications. Our domain
`.inspection.alpha.canada.ca` is managed within a DNS zone on Azure, benefiting
from direct integration with these services.

## Decision

We recommend continuing the use of Nginx Ingress, cert-manager, and vouch-proxy,
combining these services with automated DNS management via external-dns.
This setup provides robustness, flexibility, and security, in harmony with
Azure services.

## Considered Alternatives

### Istio Ingress

Advantages:

- **Service Mesh Integration:** Offers advanced management of routing,
load balancing, and security policies at the service level.

- **Granularity of Network Policies:** Enables detailed management of network
policies among services.

Disadvantages:

- **Complexity:** Its configuration and management are complex and can pose
challenges in terms of maintenance.

- **Resource Consumption:** Istio is more resource-intensive, which can be
problematic in environments with limited capacity.

### Kubernetes Gateway API

Advantages:

- **Evolving Standard:** Provides a more expressive model than traditional
Ingress with better abstraction for routes.

- **Modularity and Flexibility:** Offers extensive customization in managing
traffic and routes.

Disadvantages:

- **Maturity and Adoption:** Given its novelty, the adoption of the Gateway API
is not yet widespread and may lack support compared to established solutions.

- **Possible Redundancy:** Some capabilities may overlap with those provided by
Nginx Ingress, potentially requiring a reevaluation of the tools in place.

## Conclusion

The current configuration using Nginx Ingress, cert-manager, vouch-proxy,
and external-dns for automated DNS record management provides an optimal
balance between efficiency, security, and simplified management in our Azure
environment. These choices support our strategy to maintain a stable
architecture while fully leveraging the skills and technologies we are already
proficient in. Continuing on this path allows us to benefit from strong
integration and support by Azure, while facilitating the scalability and
maintenance of our networking services.

## References

- [Implementation for the Howard project](
https://github.com/ai-cfia/howard/blob/main/docs/networking.md)
- [Implementation of Vouch proxy for the Howard project](
https://github.com/ai-cfia/howard/blob/main/docs/auth-workflow.md)
- [Istio ingress](
https://istio.io/latest/docs/tasks/traffic-management/ingress/)
- [Kubernetes gateway api](https://gateway-api.sigs.k8s.io/)
- [Ingress NGINX](https://docs.nginx.com/nginx-ingress-controller/)
- [Cert manager](https://cert-manager.io/)
- [External DNS](https://github.com/kubernetes-sigs/external-dns)

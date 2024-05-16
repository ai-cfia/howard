# ADR-015: User Authentication Management

## Executive Summary

As part of the centralized management of user authentication for our
applications, particularly the Nachet application, we have chosen to implement
Vouch-proxy. This solution was selected for its ability to efficiently integrate
authentication services such as Azure and Github, while retrieving user group
information in a token. Vouch-proxy allows us to apply uniform and secure
authentication management across all services hosted on our Kubernetes cluster,
thanks to its integration with NGINX ingress. This choice aims to improve
security while offering increased flexibility and scalability for our identity
and access management operations.

## Context

Some of our applications, including the Nachet application, require
authentication to access their services. Initially, Nachet was deployed without
authentication mechanisms, allowing any user to view the page and potentially
insert malicious images. Given this vulnerability, and to secure access to all
applications on our Kubernetes cluster, it became imperative to adopt a
centralized authentication solution. This solution must also be capable of
integrating with identity providers such as Azure and Github, and retrieving
user groups in a token for fine-grained authorization management.

## Decision

After evaluating several alternatives, we opted for the use of Vouch-proxy to
meet our needs for centralized authentication. Vouch-proxy stands out for its
compatibility with identity providers Azure and Github, thus facilitating user
authentication while retrieving essential group information in a token. This
capability is crucial for managing permissions within our services. Moreover,
Vouch-proxy integrates seamlessly with the NGINX ingress of our Kubernetes
cluster, enabling centralized management of authentication for all our services.
This centralized approach ensures enhanced security and better consistency in
managing user access across different applications.

## Considered Alternatives

### Ori network (Ori Oathkeeper, Ori Kratos)

Advantages:

- Ori Oathkeeper is an authentication and authorization proxy that can be used
  to centrally manage the authentication of users and services. Ori Kratos is an
  identity and access service that can be used to centrally manage users and
  roles. The advantage of these solutions is that they can be used as a complete
  solution for managing the authentication and authorization of users and
  services.

Disadvantages:

- Ori Oathkeeper and Ori Kratos are relatively new solutions and have proven to
  be less mature than other authentication solutions. We attempted a deployment
  of Kratos and encountered configuration issues, among others. The
  documentation is also less comprehensive than that of other solutions.

### Oauth2-Proxy

Advantages:

- Oauth2-Proxy is an authentication proxy that can be used to manage user
  authentication and can be configured with NGINX ingress.

Disadvantages:

- Oauth2-Proxy is configurable to manage authentication on a one-for-one basis
  but is not designed to handle centralized authentication for multiple
  services. Vouch-proxy is a more suitable alternative for our needs for
  centralized authentication management.

### Custom Authentication Solution

Advantages:

- Precise adaptation: A custom solution offers the possibility to develop an
  authentication system that precisely matches the specific requirements of our
  infrastructure and applications. This allows for finer integration and
  adaptation to internal processes.
- Complete control: By designing our own solution, we have total control over
  security and functionality aspects, allowing us to adjust or improve the
  solution based on evolving security needs and user management.

Disadvantages:

- High development cost and time: Designing a custom solution requires a
  significant initial investment in time and human resources.
- Maintenance and updating: Post-development operational costs can be
  significant, including regular maintenance and updates necessary to meet new
  security threats and legal requirements.
- Competitiveness and maturity: It is challenging for an in-house solution to
  compete with the features and security offered by proven solutions on the
  market, which benefit from continuous development and feedback from a broad
  user base.

## Consequences

The adoption of Vouch-proxy for centralized authentication within our
infrastructure has significant implications, both positive and negative. On the
positive side, this decision will enhance the security of our applications by
effectively integrating robust authentication services such as Azure and Github,
while facilitating the management of access rights through the retrieval of user
groups in a token. This will also simplify the administration of our systems and
improve the consistency of the user experience across different applications.
However, it is essential to recognize that this implementation will require
technical adjustments, particularly in configuring and maintaining the NGINX
ingress, and could introduce initial complexity during the integration phase.
Moreover, this decision commits the company to the longevity and evolution of
Vouch-proxy, as well as the stability of its integrations with identity
providers. It will therefore be crucial to closely monitor these aspects and
plan actions for necessary updates and potential adjustments in response to
challenges that may arise.

## References

- [Oauth2-Proxy](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Vouch-proxy](https://github.com/vouch/vouch-proxy)
- [Ori Oathkeeper](https://www.ory.sh/oathkeeper/)
- [Ori Kratos](https://www.ory.sh/kratos/)
- [Example of implementing authentication with Express Web
  app](https://learn.microsoft.com/en-us/entra/identity-platform/tutorial-v2-nodejs-webapp-msal)

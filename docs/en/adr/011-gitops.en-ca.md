# ADR-011: GitOps

## Introduction

This document outlines the decision to use ArgoCD as the
continuous deployment tool for our Kubernetes applications.

## Background

Before implementing ArgoCD, the process of addressing production issues was
manual and time-consuming. A developer had to report an issue to a DevSecOps,
which could result in a waiting period before the issue was resolved.

## Use Cases

- Developers can deploy and test their changes without waiting for
a DevSecOps intervention.

- Developers can identify and resolve production issues more quickly.

- Development and operations teams can work more closely together.

## Decision

The team has already had positive experiences with ArgoCD.

## Considered Alternatives

### Flux

Advantages:

- Easy to set up

Disadvantages:

- No user interface

## Consequences

- Developers will be able to deploy and test their changes more quickly.

- Production issues can be resolved more swiftly.

- Development and operations teams can work more closely together.

## References

- [ArgoCD ACIA/CFIA url](https://argocd.inspection.alpha.canada.ca/)
- [Document on Secret Management](../secrets-management.md)

# ADR-011 : GitOps

## Introduction

Ce document présente la décision d'utiliser ArgoCD comme outil de déploiement
continu pour nos applications Kubernetes.

## Contexte

Avant l'implémentation d'ArgoCD, le processus de résolution des problèmes
de production était manuel et chronophage. Un développeur devait remonter
un problème à un DevSecOps, ce qui pouvait entraîner un délai d'attente
avant la résolution du problème.

## Cas d'utilisation

- Les développeurs peuvent déployer et tester leurs modifications sans avoir
à attendre l'intervention d'un DevSecOps.

- Les développeurs peuvent identifier et résoudre les problèmes de production
plus rapidement.

- Les équipes de développement et d'opérations peuvent travailler
plus étroitement ensemble.

## Décision

L'équipe a déjà une expérience positive avec ArgoCD.

## Alternatives Considérées

### Flux

Avantages:

- Facile à configurer

Inconvénients:

- Absence d'interface utilisateur

## Conséquences

- Les développeurs pourront déployer et tester leurs modifications
plus rapidement.

- Les problèmes de production pourront être résolus
 plus rapidement.

- Les équipes de développement et d'opérations pourront
travailler plus étroitement ensemble.

## Références

- [ArgoCD ACIA/CFIA url](https://argocd.inspection.alpha.canada.ca/)
- [Document sur la gestion des secrets](../secrets-management.md)

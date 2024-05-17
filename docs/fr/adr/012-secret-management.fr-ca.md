# ADR-012 : Gestion des secrets

## Résumé Exécutif

Après une analyse approfondie des options disponibles pour la gestion des
secrets, nous avons décidé d'adopter HashiCorp Vault. Cette solution se
distingue par sa forte intégration avec Kubernetes, sa capacité à gérer les
secrets au sein des applications, son intégration avec ArgoCD, et sa méthode
sécurisée de partage des secrets. Ces caractéristiques alignent Vault avec nos
objectifs d'agilité, de sécurité, et d'efficacité dans la gestion des secrets
pour nos services hébergés.

## Contexte

La gestion sécurisée des secrets est cruciale pour la protection des
informations sensibles et la sécurisation de notre infrastructure. Dans notre
environnement, où Kubernetes joue un rôle central dans la gestion des services
hébergés, il est essentiel de choisir une solution de gestion des secrets qui
s'intègre bien avec cet écosystème, tout en offrant flexibilité et sécurité. De
plus, notre utilisation d'ArgoCD pour l'automatisation du déploiement exige que
notre solution de gestion des secrets puisse s'intégrer sans heurt, facilitant
une gestion cohérente et sécurisée des secrets à travers nos pipelines CI/CD.

## Décision

Nous avons choisi HashiCorp Vault comme notre solution principale pour la
gestion des secrets. Vault offre une intégration étroite avec Kubernetes,
permettant une gestion efficace des secrets au sein des applications. Cette
intégration se manifeste par le Vault Kubernetes Auth Method, qui autorise les
applications tournant dans Kubernetes à accéder aux secrets stockés dans Vault
en utilisant les jetons de service Kubernetes pour l'authentification.

Vault facilite également la rotation dynamique des secrets, garantissant que les
informations sensibles ne restent pas statiques et sont régulièrement
actualisées sans intervention manuelle. Cette caractéristique est essentielle
pour maintenir une posture de sécurité élevée et réduire la surface d'attaque
potentielle liée à des secrets compromis.

En outre, Vault peut générer des secrets à la demande pour les bases de données
et d'autres services, ce qui réduit le besoin de stocker des secrets statiques
et augmente l'efficacité de la gestion des secrets. L'intégration de Vault avec
ArgoCD à travers des plugins comme le Argo CD Vault Plugin simplifie le
déploiement des applications en s'assurant que les secrets nécessaires sont
injectés au moment du déploiement de manière sécurisée.

Choisir une instance centralisée et auto-hébergée de Vault donne un contrôle
total sur la gestion des secrets et assure une conformité avec les exigences de
souveraineté des données, en permettant de stocker et gérer les secrets au sein
de notre propre infrastructure sans dépendre de tiers.

L'adoption de Vault facilite également l'implémentation de pratiques GitOps pour
la gestion des configurations et des secrets, en assurant que toutes les
modifications sont traçables, révisables et déployées à travers des processus
d'intégration et de déploiement continus.

## Alternatives Considérées

### Azure Key Vault

Avantages :

- Intégration native avec l'écosystème Azure, facilitant la gestion des secrets
  pour les ressources Azure.

Inconvénients :

- Limité principalement à l'écosystème Azure, présentant des défis pour les
  déploiements multi-cloud ou hybrides.

- Moins d'intégration native avec Kubernetes comparé à HashiCorp Vault, ce qui
  pourrait complexifier la gestion des secrets dans nos applications Kubernetes.

- Azure Key Vault ne peut pas être auto-hébergé, ce qui peut poser des problèmes
  de souveraineté des données et de conformité.

- Le Github action pour Azure Key Vault est obsolète et n'est plus maintenu. La
  seule facon d'obtenir des secrets d'Azure Key Vault dans un pipeline est
  d'utiliser un script personnalisé. Ceci est expliquer dans leur repertoire
  archivé.

- Azure Key Vault ne supporte pas le versionnement des secrets et ne permet pas
  de gérer les secrets de manière GitOps.

### Mozilla SOPS

Avantages :

- SOPS est un outil de gestion de secrets qui permet de chiffrer/déchiffrer le
  contenu d'un fichier avec une clé dérivée d'AWS, KMS, GCP KMS, Azure Key Vault
  ou PGP, garantissant que les secrets sont toujours chiffrés et peuvent être
  facilement intégrés dans les systèmes de contrôle de version.

Inconvénients :

- SOPS n'est pas une solution de gestion de secrets qui remplit tous nos besoin
  de facon autonome. Il ne gère pas le stockage de secret dans un endroit
  centralisé, ni la rotation des secrets.

## Conséquences

L'adoption de HashiCorp Vault nous permettra de renforcer la sécurité de notre
infrastructure en centralisant la gestion des secrets dans un outil conçu
spécifiquement pour cela. L'intégration avec Kubernetes et ArgoCD soutient nos
efforts d'automatisation et d'efficacité, en assurant que les secrets soient
gérés et déployés de manière sécurisée dans notre environnement. Cette décision
nécessitera une formation de nos équipes sur Vault et l'ajustement de nos
processus existants pour intégrer pleinement Vault dans notre pipeline CI/CD.

## Références

- [Documentation sur notre configuration et utilisation de HashiCorp
  Vault](../secrets-management.md)
- [Documentation officielle de HashiCorp
  Vault](https://developer.hashicorp.com/vault/docs?product_intent=vault)
- [Intégration de HashiCorp Vault avec
  Kubernetes](https://www.vaultproject.io/use-cases/kubernetes)
- [Guide sur l'intégration de HashiCorp Vault avec
  ArgoCD](https://github.com/argoproj-labs/argocd-vault-plugin)
- [Vault-action pour intégrer Vault dans nos pipelines
  CI/CD](https://github.com/hashicorp/vault-action)
- [Aperçu Azure Key
  Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
- [Repertoire Mozilla SOPS](https://github.com/getsops/sops)
- [Azure key vault action
  obsolète](https://github.com/Azure/get-keyvault-secrets)

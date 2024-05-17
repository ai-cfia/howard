# Howard : Infrastructure Cloud de l'Agence canadienne d'inspection des aliments (ACIA) ACIA-CFIA ai-Lab

## À propos du projet

Le projet Howard est nommé d'après Luke Howard, FRS, un chimiste manufacturier
et météorologue amateur britannique notable connu sous le nom de
"Le Parrain des Nuages". Son travail a jeté les bases de concepts en
météorologie, notamment un système de nomenclature pour les nuages introduit
en 1802. Inspiré par son innovation et son héritage dans la catégorisation des
éléments, notre projet vise à gérer et orchestrer efficacement l'infrastructure
basée sur le cloud pour le laboratoire d'intelligence artificielle (ai-lab)
de l'Agence canadienne d'inspection des aliments (ACIA).

Howard est essentiellement la colonne vertébrale qui soutient l'environnement
Kubernetes du laboratoire d'intelligence artificielle de l'ACIA, où des
applications clés telles que Nachet, Finesse et Louis sont déployées et gérées
de manière dynamique. Cette infrastructure met l'accent sur la robustesse, la
sécurité et l'efficacité pour traiter la charge de travail critique impliquée
dans l'inspection et la sécurité alimentaire.

## Ensemble de technologies et outils

L'infrastructure Howard s'appuie sur une suite complète d'outils conçus pour
fournir un environnement résilient, sécurisé et évolutif :

### Fournisseurs de cloud

- Initialement hébergée sur Google Cloud, l'infrastructure a
été transférée sur Azure.

### Orchestration des conteneurs

**Kubernetes :** Orchestrer le déploiement, la mise à l'échelle et la
gestion des conteneurs.

### GitOps

**ArgoCD :** Utilisé pour la livraison continue, gestion des ressources
Kubernetes de manière déclarative via des dépôts Git.

### Surveillance et sécurité

- **Grafana :** Logiciel de visualisation et d'analytique.
- **Kube-Prometheus-Stack :** Surveillance complète des clusters Kubernetes
avec Prometheus.
- **Falco :** Outil de sécurité open-source en temps réel.
- **Trivy :** Scanner de vulnérabilités pour les conteneurs.
- **Oneuptime :** Outil de surveillance pour des informations sur la
performance et la sécurité en temps réel.

### Réseautage

- **Vouch-Proxy :** Proxy d'authentification.
- **Nginx Ingress :** Contrôleur d'entrée pour Kubernetes utilisant NGINX comme
proxy inverse et équilibreuse de charge.
- **Istio :** Maillage de services qui fournit une interface sécurisée pour la
communication entre services.

### Gestion des secrets

**HashiCorp Vault :** Sécurise, stocke et contrôle strictement l'accès aux
jetons, mots de passe, certificats et autres secrets.

### Gestion de l'infrastructure cloud

- **Terraform :** Outil open-source d'infrastructure en tant que code permettant
de gérer le cycle de vie des services chez les fournisseurs cloud
de manière déclarative.
- **Ansible :** Outil d'automatisation pour la configuration et la gestion
des ordinateurs.

## Installation

### Déploiement Terraform

La configuration actuelle héberge un cluster Kubernetes sur Azure (AKS). Nous
disposons d'un pipeline Azure DevOps apply-terraform.yml qui applique les
ressources Terraform créées sur notre abonnement Azure. L'état est ensuite
sauvegardé dans un stockage blob d'Azure.

### Configuration de Kubectl

En supposant que vous ayez installé Azure CLI et le plugin kubelogin, voici
comment récupérer localement la configuration kube :

```bash
az login
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
az aks get-credentials --resource-group resource-group-name --name aks-name --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

## Documentation

<https://ai-cfia.github.io/howard/fr/>

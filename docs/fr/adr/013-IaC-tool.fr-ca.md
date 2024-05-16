# ADR-013 : Gestion de l'Infrastructure as Code (IaC)

## Résumé Exécutif

Nous avons décidé d'adopter Terraform comme solution d'Infrastructure as Code
(IaC) pour la gestion et le déploiement de notre infrastructure sur plusieurs
fournisseurs de cloud. Cette décision s'appuie sur la compatibilité
interinfonuagique de Terraform, notre connaissance approfondie de l'outil, ainsi
que ses capacités de suivi d'état. Terraform offre également une maturité et une
communauté plus larges, sans être lié à un fournisseur de nuage spécifique, et
permet la création de fournisseurs d'extensibilité personnalisés.

## Contexte

Dans le cadre de notre effort pour améliorer l'efficacité et la reproductibilité
de la gestion de notre infrastructure infonuagique, nous avons évalué plusieurs
outils d'Infrastructure as Code (IaC). Notre infrastructure, bien que
principalement hébergée sur Azure pour le moment, pourrait s'étendre à d'autres
fournisseurs à l'avenir, soulignant l'importance d'un outil IaC flexible et
puissant.

L'utilisation d'un outil IaC nous permet de bénéficier du contrôle de version de
notre infrastructure, similaire à ce que Git offre pour le code source. Cela
signifie que nous pouvons suivre, réviser et reverser les changements
d'infrastructure de manière contrôlée et documentée. De plus, un outil IaC
réduit considérablement le temps requis pour la provision et la gestion de
l'infrastructure, car il permet de déployer et d'actualiser l'infrastructure à
travers des fichiers de configuration au lieu de procédures manuelles. Cette
approche garantit également un environnement plus cohérent, en réduisant les
divergences entre les environnements de développement, de test, et de
production. Enfin, en automatisant la gestion de l'infrastructure, nous
minimisons le risque d'erreurs humaines, améliorant ainsi la sécurité et la
fiabilité de nos systèmes.

## Décision

Après une évaluation approfondie, nous avons choisi Terraform comme notre outil
de gestion d'infrastructure. Cette décision repose sur plusieurs facteurs clés :
Notre expérience existante avec cet outil, la compatibilité inter-cloud de
Terraform grâce à un modèle de travail cohérent à travers un langage descriptif
et sa fonctionnalité de fichier d'état qui facilite le suivi des changements
d'infrastructure. De plus, la maturité de Terraform et sa vaste communauté
offrent une assurance supplémentaire quant à la fiabilité et l'évolutivité de
cet outil. Terraform nous permet également de créer des fournisseurs
d'extensibilité personnalisés, une fonctionnalité essentielle pour notre projet
qui nécessitent l'intégration avec HashiCorp Vault et GitHub. Ainsi, Terraform
nous permet d'utiliser des fournisseurs tels que Helm, Kubernetes, ArgoCD, Azure
DevOps, GitHub, Ansible, et bien d'autres encore.

## Alternatives Considérées

### Bicep

Avantages :

- Intégration native avec Azure, offrant une expérience simplifiée pour la
  gestion des ressources Azure.
- Syntaxe simplifiée par rapport à des outils plus anciens comme Azure Resource
  Manager (ARM) templates.

Inconvénients :

- Absence de gestion d'état intégrée : contrairement à Terraform qui dispose
  d'une fonctionnalité de fichier d'état permettant de suivre et de gérer les
  changements dans l'infrastructure (si un élément est supprimé du code de
  déploiement, Terraform procède à sa destruction), Bicep ne possède pas de
  concept similaire. Cela signifie que les modifications ou suppressions
  d'éléments nécessitent une intervention manuelle ou une logique supplémentaire
  pour gérer l'état de l'infrastructure.
- Limité principalement à l'écosystème Azure, ce qui pose des défis pour les
déploiements multi-infonuagiques.
- La création de fournisseurs d'extensibilité personnalisés est encore en phase
  expérimentale.

### CloudFormation

Avantages :

- Intégration profonde avec l'écosystème AWS, facilitant la gestion des
  ressources AWS.

Inconvénients :

- Confiné à l'écosystème AWS, limitant la flexibilité pour les déploiements
  multi-cloud.
- Moins de support pour l'extensibilité personnalisée par rapport à Terraform.

### Pulumi

Avantages :

- Langages de Programmation Familiers : Pulumi permet aux développeurs
  d'utiliser des langages de programmation généraux tels que TypeScript, Python,
  Go, et .NET, ce qui peut réduire la courbe d'apprentissage et faciliter
  l'intégration dans les pipelines CI/CD existants.
- État Géré en Cloud : Pulumi gère l'état de l'infrastructure dans le cloud,
  offrant une approche centralisée et sécurisée pour le suivi des déploiements
  d'infrastructure.
- Support Multi-Cloud et On-Premise : Pulumi fournit une large prise en charge
  des fournisseurs de cloud, y compris Azure, AWS, Google Cloud, ainsi que des
  ressources on-premise, offrant une grande flexibilité pour les déploiements
  hybrides et multi-cloud.

Inconvénients :

- Complexité potentielle : L'utilisation de langages de programmation complets
  peut introduire une complexité supplémentaire dans la gestion de
  l'infrastructure, surtout pour les équipes non familières avec ces langages.
- Dépendance sur le Service Pulumi : Bien que Pulumi offre des options pour
  gérer l'état localement ou dans le nuage, la version gérée en nuage crée une
  dépendance sur les services de Pulumi, ce qui apporte des préoccupations
 vis-à-vis la souveraineté des données ou les coûts supplémentaires.
- Moins Mature que Terraform : Pulumi est plus récent sur le marché de l'IaC que
  Terraform, ce qui signifie qu'il pourrait avoir une communauté plus petite et
  moins de ressources disponibles pour le dépannage et l'apprentissage comparé à
  Terraform.

## Conséquences

L'adoption de Terraform comme notre outil IaC principal nous permettront
d'unifier la gestion de notre infrastructure à travers divers fournisseurs,
améliorant ainsi l'efficacité et réduisant le risque d'erreurs manuelles. Cela
nécessitera une formation continue pour nos équipes afin d'exploiter pleinement
les capacités de Terraform. Nous anticipons également une amélioration de la
collaboration entre les équipes de développement, d'opérations et de sécurité
grâce à une approche cohérente de la gestion des infrastructures. La décision
soutient notre objectif d'agilité et de sécurité dans le développement et le
déploiement de nos applications, tout en promouvant l'utilisation de solutions
qui nous permet d'être open source pour une plus grande transparence et
collaboration.

## Références

- [Documentation sur le flux de travail avec Terraform pour faire le déploiement
  de nos
  services](https://github.com/ai-cfia/howard/blob/main/docs/terraform-workflow.md)
- [Code source de l'infrastructure
  (Howard)](https://github.com/ai-cfia/howard/tree/main/terraform)
- [Site officiel de Terraform](https://www.terraform.io/)
- [Documentation de
  Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Repertoire Github de Pulumi](https://github.com/pulumi/pulumi)
- [Guide de l'utilisateur AWS
  CloudFormation](https://docs.aws.amazon.com/cloudformation/)
- [Extensibilité de fournisseurs en phase expérimentale pour
Biceps](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import#import-namespaces-and-extensibility-providers-preview)

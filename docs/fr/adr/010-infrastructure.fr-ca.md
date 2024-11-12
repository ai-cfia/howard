# ADR-010 : Infrastructure

## Résumé Exécutif

Dans un effort d'optimisation et de sécurisation de nos opérations
d'infrastructure, notre organisation a adopté une stratégie basée sur
l'Infrastructure as Code (IaC) en utilisant Terraform, accompagnée par le
déploiement d'un cluster Kubernetes sur Azure. Cette approche nous permet de
surmonter les limitations associées aux méthodes traditionnelles telles que
ClickOps et les déploiements manuels, qui étaient à la fois chronophages et
susceptibles d'erreur. L'adoption de HashiCorp Vault pour la gestion centralisée
des secrets et d'ArgoCD pour l'orchestration des déploiements renforce notre
posture de sécurité et d'agilité. En intégrant des solutions de monitoring
avancées et en envisageant l'utilisation de technologies comme OpenTelemetry
pour une observabilité accrue, nous visons à maintenir une haute disponibilité
et performance de nos services. Cette transformation permet une gestion plus
robuste et automatisée de l'infrastructure, réduit les risques d'erreur humaine
et offre une flexibilité et une portabilité accrues à travers différents
environnements cloud. Notre initiative aligne la gestion des infrastructures
avec nos objectifs opérationnels tout en assurant une évolutivité et une
sécurité renforcées pour répondre aux besoins futurs.

## Contexte

Notre équipe fait face à des défis en matière de déploiement de solutions,
notamment dans le choix des fournisseurs d'infonuages. Initialement, nous
utilisions [Google Cloud Run](https://cloud.google.com/run/?hl=en) et Azure App
Service. Cependant, en
raison de l'absence de compte Google Cloud et des restrictions d'accès sur
Azure, nous nous retrouvons à basculer d'un compte à l'autre, entraînant
d'importants temps d'arrêt pour nos applications.

De plus, la création manuelle de tous les services sur les fournisseurs de cloud
via le ClickOps s'est avérée fastidieuse. Pour surmonter ce défi, , nous avons
décidé d'adopter l'Infrastructure as Code (IaC) en utilisant Terraform. Cette
approche nous permet de gérer et de provisionner nos infrastructures cloud via
des fichiers de configuration codifiés, éliminant ainsi le besoin de ClickOps et
réduisant significativement les erreurs humaines.

En ce qui concerne la sécurité, nous avions initialement adopté Azure Key Vault
pour la récupération manuelle des valeurs des variables d'environnement.
Cependant, reconnaissant la nécessité d'une solution plus robuste et polyvalente
pour la gestion des secrets, nous avons évolué vers le maintien d'une instance
de HashiCorp Vault. Cette transition permet une gestion centralisée des secrets
et des identifiants à travers différents environnements et plateformes.

La mise à l'echelle de nos applications n'est pas actuellement une priorité, car
nous avons une visibilité fixe sur le nombre d'utilisateurs. Cependant, nous
n'avons pas encore mis en oeuvre de solution de mise à l'échelle.

Actuellement, pour le monitoring et la télémétrie, nous nous appuyons
exclusivement sur les outils intégrés des fournisseurs de cloud, comme ceux de
Google Cloud Run. Cependant, il est important de considérer la flexibilité et la
portabilité que peuvent offrir des services externes tels
qu'[OpenTelemetry](https://opentelemetry.io/). Ces solutions peuvent non
seulement s'adapter à divers environnements de cloud mais aussi offrir une
personnalisation poussée qui répond spécifiquement à nos besoins. Bien que les
solutions maison puissent sembler exigeantes en termes de maintenance, elles
nous permettent d'optimiser notre surveillance et notre télémétrie de manière
ciblée, offrant ainsi un potentiel d'alignement plus précis avec nos objectifs
opérationnels.

Bref, de nombreuses tâches sont actuellement effectuées manuellement. Bien que
nous disposions de Github Workflow pour déployer des images Docker, la gestion
des déploiements sur différents fournisseurs d'infonuages n'est pas automatisée.
En cas d'erreur en production, aucune solution ne permet aux développeurs de
résoudre rapidement le problème

## Cas d'utilisation

- Gérer la base de données PostgreSQL (et bientôt PostgreSQL ML) sans recourir
  au ClickOps.
- Accroître la redondance des données de manière plus efficace.
- Déployer, gérer, surveiller et instrumenter les applications au sein de
  l'organisation.
- Améliorer la gestion des secrets.
- Éliminer les silos entre l'équipe de sécurité et l'équipe DevOps au sein de
  l'organisation
- Mettre en place des déploiements sur tous les fournisseurs de cloud en cas de
  pannes. Cela inclue une persistences des données dans les différents
  fournisseurs d'infonuages.
- Gérer une solution SSO centralisé pour authentifier les utilisateurs des
  services hébergés.
- Utiliser l'Infrastructure as Code pour automatiser la création, le
  déploiement, et la gestion de l'infrastructure permettant la rapidité des
  opérations d'infrastructure tout en réduisant les erreurs manuelles.
- Automatisation de la mise à l'échelle (HPA).
- Adopter une stratégie de sauvegarde et de reprise après sinistre.
- Créer une documentation facile de lecture et d'adaption pour permettre une
  transition "shift-left" (Intégration anticipée et approfondie des tests, de la
  sécurité et de l'assurance qualité au début du cycle de développement
  logiciel, pour une identification et résolution plus précoces des anomalies).
- Éviter les points de défaillance uniques.

## Décision

Notre solution consistera à déployer des clusters Kubernetes sur différents
fournisseurs de cloud. Voici les composants qui seront déployés pour gérer
divers cas d'utilisation

- [Gestion des conteneurs et leur déploiement:
  Kubernetes](014-containers.fr-ca.md)
- [Gestion des secrets: HashiCorp Vault](012-secret-management.fr-ca.md)
- [Gestion des deployments: ArgoCD](011-gitops.fr-ca.md)
- [Gestion de l'Infrastructure as Code (IaC): Terraform](013-IaC-tool.fr-ca.md)
- Gestion des environnements de développement: AzureML (à venir)
- [Gestion d'authentification des utilisateurs:
  Vouch-proxy](015-authentication-management.fr-ca.md)
- Gestion de l'observabilité: Grafana, Prometheus, Open-Telemetry et OneUptime
  (À venir)
- [Gestion du load balancing: Ingress NGINX](016-networking.fr-ca.md)
- [Gestion de la securité: Trivy et Falco](017-security.fr-ca.md)
- Gestion de la redondance: Istio / Cluster mesh (à venir)

D'autres composants seront ajoutés au besoin.

## Conséquences

La transition vers une gestion d'infrastructure basée sur Kubernetes et
Terraform, combinée à l'utilisation de solutions robustes pour la gestion des
secrets (HashiCorp Vault) et des déploiements (ArgoCD), marque un progrès
significatif vers une automatisation complète et une sécurisation accrue de
notre environnement cloud.

Cette approche permet de minimiser les interventions manuelles et les risques
d'erreur, tout en renforçant la sécurité à chaque étape du déploiement des
applications. En utilisant des outils open source, nous favorisons une plus
grande transparence, une adaptabilité aux environnements multiples et une
intégration plus aisée avec divers écosystèmes. De plus, l'adoption de pratiques
GitOps, notamment à travers Terraform et ArgoCD, améliore la traçabilité et la
réversibilité des changements apportés à l'infrastructure, essentielles pour la
gestion des configurations et la conformité sécuritaire. Ces changements
soutiennent notre capacité à évoluer rapidement et de manière fiable, tout en
maintenant un contrôle rigoureux sur la sécurité des données et
l'authentification des utilisateurs à travers Vouch-proxy et l'intégration de
solutions telles que NGINX Ingress pour la gestion de l'accès. Cependant, cette
évolution nécessite une montée en compétence continue de nos équipes et une
attention soutenue aux mises à jour et à l'entretien de ces technologies pour
garantir leur efficacité et leur sécurité à long terme.

## Références

- [Repertoire Howard - Contient la configuration de notre infrastructure
  accompagnée de documentation](https://github.com/ai-cfia/howard)
- Azure App Service : `https://azure.microsoft.com/en-ca/products/app-service/`

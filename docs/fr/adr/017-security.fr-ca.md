# ADR-017 : Sécurité

## Résumé exécutif

Cet ADR documente et formalise l'amélioration de notre stratégie de sécurité à
travers la gestion et la surveillance des vulnérabilités au sein de notre
infrastructure Kubernetes. Nous avons enrichi nos capacités de sécurité en
intégrant trivy-operator et Falco pour les scans statiques et dynamiques, tout
en continuant d'utiliser Dependabot pour les dépendances de code. Par ailleurs,
nous avons adopté Mend Renovate pour automatiser les mises à jour des images
Docker, des providers Terraform, et autres dépendances à des fins de maintien
des versions les plus sécurisées. Le suivi et la visualisation de ces mesures
de sécurité sont réalisés à travers des dashboards Grafana.

## Contexte

Traditionnellement, notre stratégie de sécurité s'appuyait principalement sur
Dependabot pour les alertes de sécurité concernant les dépendances de notre
code. Face à des exigences de sécurité accrues et à la nécessité de couvrir
les vulnérabilités tant au niveau statique que dynamique, nous avons élargi
notre suite d'outils de sécurité.

## Décision

Nous avons renforcé notre architecture de sécurité en intégrant les outils
suivants :

- **Trivy-operator :** réalise des scans statiques de notre cluster et des
images des conteneurs de nos pods pour détecter les vulnérabilités avant
leur déploiement.

- **Falco :** effectue des scans dynamiques pour surveiller le comportement en
temps réel des applications et détecter toute activité anormale ou suspecte.

- **Mend Renovate :** automatise la mise à jour des versions de nos images
Docker, des providers Terraform, et d'autres dépendances, assurant l'usage des
versions les plus récentes et sécurisées.

Ces outils sont complémentés par des dashboards Grafana, permettant une
visualisation en temps réel et une gestion des alertes de sécurité,
facilitant une intervention rapide et éclairée.

## Alternatives Considérées

### Snyk

Avantages :

- **Sécurité proactive :** Snyk offre une solution proactive en testant les
dépendances et les conteneurs en quête de vulnérabilités et en proposant
des corrections automatisées.

- **Large éventail d'intégrations :** S’intègre facilement avec des outils de
CI/CD et des plateformes d'hébergement, comme GitHub et Bitbucket, pour une
détection et une correction automatisée des vulnérabilités au sein du pipeline
de développement.

Inconvénients :

- **Coût potentiellement élevé :** Les fonctionnalités avancées de Snyk peuvent
représenter un coût significatif, surtout pour les grandes organisations
avec de nombreux environnements à gérer.

- **Apprentissage et configuration :** La mise en place et l'optimisation de
Snyk pour des environnements spécifiques peuvent requérir un certain temps
d'adaptation et de configuration.

### Sysdig Secure

Avantages :

- **Inspection détaillée :** Permet une analyse approfondie du trafic
réseau et du système de fichiers en temps réel.

- **Compatibilité étendue :** Compatible avec la plupart des environnements
de cloud et d'orchestrateurs de conteneurs.

Inconvénients :

- **Utilisation intensive des ressources :** Peut consommer une quantité
significative de ressources système, impactant les performances.

- **Complexité d'intégration :** Bien que puissant, il peut s'avérer difficile
à intégrer et nécessite une maintenance régulière pour rester synchronisé
avec les mises à jour des systèmes et des orchestrateurs.

## Conclusion

L'intégration de trivy-operator, Falco, et Mend Renovate, en complément à
Dependabot, constitue un renforcement significatif de notre stratégie de
sécurité, permettant d'aborder de manière proactive et en temps réel les
vulnérabilités dans notre infrastructure Kubernetes. Cette stratégie
multilatérale, soutenue par une visualisation claire via Grafana, garantit
que nous maintenons une posture de sécurité solide, essentielle pour
la fiabilité et la performance de nos services.

## Références

- [Falco](https://falco.org/)
- [Trivy](https://www.aquasec.com/products/trivy/)
- [MEND Renovate](https://docs.renovatebot.com/)
- [Dependabot](
https://github.blog/2020-06-01-keep-all-your-packages-up-to-date-with-dependabot/)
- [Snyk](https://snyk.io/fr/)
- [Sysdig secure](https://docs.sysdig.com/en/docs/sysdig-secure/)

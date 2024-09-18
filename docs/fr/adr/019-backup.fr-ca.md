# ADR-019: Gestion des sauvegardes

## Résumé Exécutif

Nous avons décidé de mettre en œuvre Azure Backup pour gérer les sauvegardes
de nos applications hébergées sur Azure Kubernetes Service (AKS). Cette
décision est motivée par la facilité d'intégration, le jeu de fonctionnalités
complet et la simplicité opérationnelle offerts par Azure Backup dans notre
écosystème Azure existant. En tirant parti d'Azure Backup avec des politiques
définies, nous visons à protéger nos clusters Kubernetes contre la perte de
données et à assurer une récupération rapide en cas d'incidents.

## Contexte

À l'Agence canadienne d'inspection des aliments, assurer la résilience des
données et leur disponibilité est primordial en raison de la nature critique
de nos applications et services. Nos applications sont hébergées sur Azure
Kubernetes Service (AKS), offrant une solution d'orchestration de conteneurs
hautement disponible et automatisée. Cependant, pour atténuer les risques
associés à la perte de données, à la corruption ou aux suppressions
involontaires, nous avons besoin d'une solution de sauvegarde.

Notre objectif était d'identifier une solution de gestion des sauvegardes
capable de s'intégrer de manière transparente à notre infrastructure Azure
existante, de prendre en charge les charges de travail Kubernetes et de fournir
des capacités de sauvegarde et de récupération efficaces basées sur des
politiques. Après avoir évalué diverses options, nous avons déterminé
qu'Azure Backup répondait le mieux à nos exigences grâce à sa simplicité
d'utilisation, sa scalabilité et sa profonde intégration avec les
services Azure.

## Décision

Nous avons choisi Azure Backup pour la gestion des sauvegardes Kubernetes
car il s'intègre parfaitement avec AKS, soutenant notre objectif d'une
stratégie de sauvegarde rationalisée et efficace. Azure Backup offre des
politiques de sauvegarde automatisées, un stockage évolutif et des capacités
de restauration rapide qui correspondent à nos besoins opérationnels.

## Alternatives Considérées

### Velero

**Avantages :**

- **Open-source :** Rentable et supporté par la communauté.
- **Support multi-cloud :** Fonctionne avec divers fournisseurs
cloud et environnements sur site.
- **Flexibilité :** Offre des horaires et des politiques de
sauvegarde personnalisables.

**Inconvénients :**

- **Complexité de configuration :** Nécessite des efforts supplémentaires
de configuration et mise en place.
- **Moins intégré à Azure :** Manque certaines intégrations natives
et fonctionnalités par rapport à Azure Backup.

### Restic avec Stash

**Avantages :**

- **Open-source :** Pas de coûts de licence, développement communautaire.
- **Support des politiques :** Prend en charge les sauvegardes programmées
et les politiques.
- **Flexibilité :** Solutions de sauvegarde hautement personnalisables.

**Inconvénients :**

- **Configuration et gestion :** Nécessite une configuration initiale
significative et une gestion continue.
- **Moins mature :** Comparé à d'autres solutions de sauvegarde Kubernetes
dédiées comme Azure Backup.

## Justification du Choix d'Azure Backup

**Facilité d'intégration :**

- **Avantages :** Azure Backup s'intègre de manière native avec AKS,
simplifiant la configuration et la gestion.
- **Inconvénients :** Verrouillage avec le fournisseur Microsoft Azure.

**Politiques automatisées :**

- **Avantages :** Simplifie la gestion des sauvegardes avec une automatisation
basée sur des politiques, garantissant des sauvegardes cohérentes et fiables.
- **Inconvénients :** Flexibilité limitée par rapport à certaines alternatives
open-source.

**Scalabilité :**

- **Avantages :** Gère efficacement les besoins croissants en données sans
dégradation significative des performances, en tirant parti de
l'infrastructure évolutive d'Azure.
- **Inconvénients :** Les coûts peuvent augmenter avec une utilisation accrue
du stockage, nécessitant un suivi et une optimisation.

**Capacités de récupération :**

- **Avantages :** Fournit une récupération rapide et efficace des données,
minimisant les temps d'arrêt et les pertes de données en cas d'incidents.
- **Inconvénients :** La vitesse de récupération peut dépendre du volume
de données et des performances du réseau Azure.

## Conclusion

La mise en œuvre d'Azure Backup pour nos clusters Kubernetes dans AKS offre une
solution intégrée et transparente qui exploite notre infrastructure Azure
existante. Ce choix simplifie la gestion des sauvegardes grâce à des politiques
automatisées, un stockage évolutif et des processus de récupération efficaces.
Bien que des alternatives comme Velero et Restic avec Stash offrent des options
open-source viables, elles introduisent une complexité supplémentaire et
nécessitent un effort d'intégration plus important avec les services Azure.

L'intégration native d'Azure Backup avec AKS assure des opérations plus
fluides, une réduction des charges de gestion et des capacités de récupération
rapide, en faisant un choix optimal pour notre stratégie de sauvegarde. Cette
approche proactive améliore notre résilience des données, protégeant nos
applications et services contre la perte de données et assurant la
continuité en cas d'incidents.

## Références

- [Microsoft Azure Backup](https://azure.microsoft.com/en-us/products/backup/)
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service)
- [Velero](https://github.com/vmware-tanzu/velero)
- [Restic](https://github.com/restic/restic)
- [Stash](https://github.com/stashed/stash)

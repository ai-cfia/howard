# ADR-018 : Gestion de l'observabilité

## Résumé exécutif

Nous avons décidé de mettre en place une pile d'observabilité complète pour nos
applications hébergées sur Azure Kubernetes Service (AKS) en utilisant
OpenTelemetry, Grafana Alloy et divers composants Grafana (Loki, Tempo,
Prometheus). Cette décision vise à améliorer notre visibilité sur les
performances du système, à améliorer la surveillance des services critiques et à
fournir une solution open-source, indépendante du fournisseur, qui répond aux
exigences de notre agence.

![monitoring-stack](../img/monitoring-stack.png)

## Contexte

À l'Agence canadienne d'inspection des aliments, nous avons rencontré des défis
significatifs dans la surveillance et la compréhension des performances de nos
applications et services système sur Azure Kubernetes Service (AKS). Malgré une
haute disponibilité et une automatisation avec AKS, nous manquions de données
contextualisées pour diagnostiquer les problèmes et surveiller la santé de nos
nœuds et services tels qu'ArgoCD et NGINX Ingress, ainsi que nos applications
clientes.

Nous cherchions une solution qui offrirait une surveillance centralisée et
open-source, fournissant des informations sur l'activité, le traffic et
l'engagement avec nos applications. Notre objectif était de mettre en œuvre une
solution générique, indépendante du fournisseur, pour la collecte et l'affichage
des données de télémétrie (logs, traces et métriques) sur nos applications.
Après avoir évalué diverses options, nous avons choisi OpenTelemetry pour la
collecte de données, Grafana Alloy comme collecteur, et la suite d'outils
Grafana (Loki, Tempo, Prometheus) pour la gestion des logs, traces et métriques.

## Décision

### Source de données : OpenTelemetry

Nous avons choisi OpenTelemetry comme principale source de données pour la
collecte de télémétrie en raison de sa nature indépendante du fournisseur et de
ses API/SDK cohérents à travers plusieurs langages de programmation. Ce choix
s'aligne bien avec le paysage technologique diversifié de notre agence et assure
une large compatibilité et évolutivité.

#### Alternatives considérées pour la source de données

1. **Jaeger :**
   - **Avantages :** Excellentes capacités de traçage, intégration avec divers
     systèmes de stockage backend.
   - **Inconvénients :** Principalement axé sur le traçage, moins de support
     pour les métriques et les logs comparé à OpenTelemetry.

2. **Zipkin :**
   - **Avantages :** Simple et facile à déployer, bon support de traçage.
   - **Inconvénients :** Support limité pour les métriques et les logs, moins
     flexible qu'OpenTelemetry.

### Plateforme de données : Grafana Alloy, Loki, Tempo, Prometheus

Nous avons décidé d'utiliser Grafana Alloy comme notre collecteur OpenTelemetry,
tirant parti de sa position neutre vis-à-vis des fournisseurs et de son
intégration transparente avec les autres composants Grafana. L'attrait principal
de Grafana Alloy réside dans sa promesse de fournir une plateforme
d'observabilité unifiée, semblable à une clé maîtresse pour diverses serrures.
Cela permet une intégration transparente avec des outils tels que Prometheus
pour les métriques, Loki pour les journaux, et bien d'autres. Alloy simplifie la
pile d'observabilité, la rendant plus accessible et gérable.

Pour les sources de données, nous avons sélectionné Grafana Loki pour les
journaux, Grafana Tempo pour les traces, et Prometheus pour les métriques.

1. **Alloy :**
    - **Avantages :** Plateforme d'observabilité unifiée, neutre vis-à-vis des
      fournisseurs, intégration transparente avec les autres composants Grafana.
    - **Inconvénients :** Complexité de la configuration et de la gestion des
      solutions de stockage de journaux à grande échelle.

2. **Loki :**
    - **Avantages :** Agrégation de journaux hautement efficace, stockage
      évolutif, et intégration avec Grafana pour une visualisation transparente.
    - **Inconvénients :** Complexité de la configuration et de la gestion des
      solutions de stockage de journaux à grande échelle.

3. **Tempo :**
    - **Avantages :** Tracing distribué efficace et évolutif, s'intègre bien
      avec les tableaux de bord Grafana.
    - **Inconvénients :** Peut être gourmand en ressources, nécessite une
      configuration appropriée pour des performances optimales.

4. **Prometheus :**
    - **Avantages :** Capacités robustes de collecte et de requête de métriques,
      support solide de l'écosystème, et gestion des alertes.
    - **Inconvénients :** Peut être gourmand en ressources, en particulier à
      grande échelle, et nécessite une configuration et une maintenance
      significatives.

#### Alternatives considérées pour la plateforme de données

1. **Collecteur OpenTelemetry natif :**
    - **Avantages :**
        - **Intégration directe :** Support direct pour les protocoles
          OpenTelemetry assurant une collecte et une exportation de données sans
          couture.
        - **Hautement personnalisable :** Offre de vastes options de
          personnalisation pour adapter le pipeline d'observabilité à des
          besoins spécifiques.
    - **Inconvénients :**
        - **Configuration complexe :** Nécessite un effort significatif de
          configuration et de mise en place, ce qui peut être chronophage.
        - **Absence de tableaux de Bbord intégrés :** Ne propose pas d'outils de
          visualisation intégrés, nécessitant des intégrations supplémentaires
          pour les tableaux de bord.

2. **Azure Monitor :**
   - **Avantages :**
     - **Intégration native avec Azure :** Intégration transparente avec les
       services et ressources Azure, simplifiant la configuration et la gestion.
     - **Surveillance complète :** Offre une large gamme de fonctionnalités de
       surveillance et d'observabilité, y compris les journaux, les métriques et
       les traces.
   - **Inconvénients :**
     - **Dépendance au fournisseur :** Lié à l'écosystème Azure, limitant la
       flexibilité et la portabilité.
     - **Coûteux à grande échelle :** Les coûts peuvent augmenter rapidement,
       surtout avec de grands volumes de données.
     - **Limitations de configuration :** Capacité limitée à configurer en tant
       que code, ce qui peut entraver l'automatisation et les efforts de
       contrôle de version.
     - **Support communautaire limité :** Communauté relativement restreinte par
       rapport aux solutions open-source, ce qui peut limiter les ressources et
       le support.

3. **ClickHouse :**
    - **Avantages :**
        - **Haute performance :** Performance exceptionnelle dans la gestion de
          grands volumes de données, adapté aux analyses intensives.
        - **Évolutif :** S'adapte efficacement pour gérer des besoins croissants
          en données sans dégradation significative des performances.
    - **Inconvénients :**
        - **Configuration complexe :** Nécessite un processus de configuration
          et de mise en place complexe, rendant son adoption difficile pour les
          petites équipes.
        - **Besoin d'outils supplémentaires :** Nécessite des outils
          supplémentaires pour la visualisation et l'intégration, augmentant la
          complexité globale de la pile.

4. **Elasticsearch :**
    - **Avantages :**
        - **Capacités de recherche puissantes :** Offre des capacités de
          recherche et d'analyse robustes, idéal pour la gestion des logs.
        - **Large adoption :** Largement adopté avec une grande communauté,
          offrant de nombreuses ressources et un support étendu.
    - **Inconvénients :**
        - **Intensif en ressources :** Peut être gourmand en ressources,
          nécessitant une infrastructure substantielle pour fonctionner
          efficacement.
        - **Coûteux à grande échelle :** Les coûts peuvent augmenter rapidement,
          en particulier lorsque l'on traite de grands volumes de données.

### Consommation : Grafana

Pour la visualisation des données et la création de tableaux de bord, nous avons
choisi Grafana en raison de son support robuste pour diverses sources de
données, de sa communauté étendue et de ses capacités puissantes de création de
tableaux de bord. Grafana nous permet de créer des tableaux de bord
personnalisés pour surveiller divers aspects de notre système, y compris
l'activité des applications, le trafic et les métriques de performance.

#### Alternatives Considérées pour la Consommation

1. **Kibana :**
   - **Avantages :** Excellent pour visualiser les données stockées dans
     Elasticsearch, capacités de recherche et d'analyse puissantes.
   - **Inconvénients :** Principalement lié à l'écosystème Elasticsearch, moins
     flexible avec d'autres sources de données.

2. **Azure Log Analytics :**
   - **Avantages :** Intégration native avec les services Azure, capacités de
     surveillance complètes.
   - **Inconvénients :** Dépendance au fournisseur, support limité pour les
     sources de données non-Azure.

3. **DataDog :**
   - **Avantages :** Plateforme de surveillance et d'observabilité complète,
     intégrations solides.
   - **Inconvénients :** Propriétaire, peut être coûteux, moins flexible pour
     les intégrations open-source.

4. **Prometheus UI :**
   - **Avantages :** Support natif pour les métriques Prometheus, simple à
     utiliser.
   - **Inconvénients :** Capacités de visualisation limitées comparées à
     Grafana, principalement axé sur les métriques.

## Conclusion

La mise en œuvre d'OpenTelemetry pour la collecte de données, de Grafana Alloy
pour le traitement des données et de Grafana pour la visualisation fournit une
pile d'observabilité entièrement open-source et indépendante du fournisseur.
Cette approche améliore notre capacité à surveiller et à dépanner efficacement
nos applications et services. Les solutions choisies offrent évolutivité,
flexibilité et support communautaire robuste, garantissant que nous pouvons
répondre à nos besoins d'observabilité actuels et futurs. De plus, OpenTelemetry
est une norme largement adoptée sur le marché, permettant à nos développeurs de
travailler avec des normes industrielles. Étant donné que nous sommes aux
premiers stades de développement de nos prototypes, c'est une opportunité idéale
pour fournir une instrumentation par conception et assurer la visibilité sur les
performances dès le départ. Cette approche proactive nous aidera à optimiser les
performances et la fiabilité de nos applications dès les premières étapes du
développement.

## Références

- [Microsoft Azure Monitor et
  OpenTelemetry](https://learn.microsoft.com/en-us/azure/azure-monitor/app/opentelemetry-enable?tabs=python#why-is-microsoft-azure-monitor-investing-in-opentelemetry)
- [Grafana Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/)
- [Grafana Loki](https://grafana.com/oss/loki/)
- [Grafana Tempo](https://grafana.com/oss/tempo/)
- [Prometheus](https://prometheus.io/)
- [Documentation OpenTelemetry](https://opentelemetry.io/docs/)
- [Jaeger](https://www.jaegertracing.io/)
- [Zipkin](https://zipkin.io/)
- [ClickHouse](https://clickhouse.tech/)
- [Elasticsearch](https://www.elastic.co/elasticsearch/)
- [Kibana](https://www.elastic.co/kibana/)
- [Documentation DataDog](https://docs.datadoghq.com/)
- [Prometheus UI](https://prometheus.io/docs/visualization/browser/)

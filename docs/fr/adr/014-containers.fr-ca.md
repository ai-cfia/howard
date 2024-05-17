# ADR-014 : Conteneurisation

## Résumé exécutif

L'utilisation de conteneurs et de Kubernetes s'est avérée efficace pour la
gestion et le déploiement de nos applications. Cette approche offre plusieurs
avantages, notamment la portabilité, qui permet aux conteneurs de s'exécuter
de manière cohérente sur différents environnements, simplifiant ainsi le
développement et le déploiement. L'évolutivité est également un point fort,
car Kubernetes permet de faire évoluer facilement les applications en fonction
de la demande. En termes de fiabilité, les conteneurs et Kubernetes offrent une
meilleure résistance aux pannes et une haute disponibilité. Enfin, l'efficacité
est améliorée grâce à l'utilisation de conteneurs qui optimisent l'utilisation
des ressources et réduit les coûts.

## Contexte

Auparavant, nous déployions manuellement chaque Dockerfile sur Google Cloud Run.
Cette approche nous demandait un investissement de temps considérable,
car chaque déploiement nécessitait une intervention manuelle pour la
construction et la mise en ligne des conteneurs. Malgré la présence
systématique de Dockerfiles dans nos répertoires, le processus de
développement et de déploiement restait relativement peu automatisé.

## Décision

Pour pallier ces limitations, nous avons décidé d'adopter Kubernetes pour
l'orchestration des conteneurs. Cette transition nous permet de bénéficier d'une
gestion plus robuste et évolutive de nos applications. Cependant, le
déploiement n'est pas entièrement automatisé ; les manifestes Kubernetes
doivent être créés pour ensuite être déployés via ArgoCD, offrant ainsi un
niveau supplémentaire de contrôle et de validation avant le déploiement final.

En ce qui concerne les images Docker, nous avons mis en place un flux de travail
GitHub qui automatise le processus de construction, de "tagging" et de mise en
ligne. Cette automatisation nous permet de garantir la cohérence et la fiabilité
de nos déploiements tout en réduisant la charge de travail manuelle
et les risques d'erreurs.

## Alternatives Considérées

### Docker Swarm

Avantages:

- **Intégration native avec Docker:** Docker Swarm est étroitement intégré
à Docker et utilise le Docker API, ce qui rend la mise en place et la gestion
plus simple pour les équipes déjà habituées à Docker.

- **Facilité de déploiement:** Docker Swarm est plus simple à configurer et à
gérer par rapport à Kubernetes, ce qui peut être bénéfique pour les petites ou
moyennes infrastructures sans besoins complexes.

- **Performances:** Docker Swarm a souvent montré des performances meilleures en
termes de temps de démarrage des conteneurs et d’utilisation des ressources.

Inconvénients:

- **Scalabilité limitée:** Docker Swarm est moins adapté pour les grands
clusters que Kubernetes. Kubernetes excelle dans la gestion de clusters de
grande taille et complexes.

- **Fonctionnalités moins robustes:** Par rapport à Kubernetes, Docker Swarm
offre moins de fonctionnalités avancées comme les stratégies de déploiement
sophistiquées, la gestion avancée des volumes, et le support extensif pour
les outils de CI/CD.

- **Communauté plus petite:** La communauté autour de Docker Swarm est moins
active que celle de Kubernetes, ce qui peut impacter le support et le
développement de nouvelles fonctionnalités.

### Nomad

Avantages:

- **Simplicité et flexibilité:** Nomad est réputé pour sa simplicité et sa
flexibilité. Cela rend l'orchestrateur idéal pour les applications non
conteneurisées ainsi que pour les conteneurs.

- **Ressources hétérogènes et multi-région:** Nomad peut gérer des charges de
travail sur différents types de serveurs, y compris des environnements bare
metal, VMs ou conteneurisés, et peut gérer des clusters multi-région facilement.

- **Haute performance et efficacité:** Nomad est conçu pour être performant à
grande échelle, offrant un démarrage rapide des tâches et une surcharge
minimale.

Inconvénients:

- **Moins de fonctionnalités que certains concurrents:** Bien que Nomad soit
apprécié pour sa simplicité, il peut manquer de certaines fonctionnalités
avancées présentes dans d'autres orchestrateurs, comme Kubernetes.

- **Écosystème plus restreint:** L'écosystème autour de Nomad est moins
développé comparativement à celui de solutions plus mûres comme Kubernetes.
Ceci peut se traduire par une offre plus limitée en termes d'outils tiers,
de plugins ou d'intégrations, rendant certaines tâches plus complexes
à mettre en œuvre et à maintenir.

## Conclusion

L'adoption de Kubernetes s'est avérée être une décision judicieuse pour
la gestion et le déploiement de nos applications conteneurisées.
Cette approche a permis d'améliorer la portabilité, l'évolutivité,
la fiabilité ainsi que l'efficacité de nos applications.

## Références

[Kubernetes](https://kubernetes.io/)

[Docker](https://www.docker.com/)

[Docker swarm](https://docs.docker.com/engine/swarm/)

[Nomad](https://www.nomadproject.io/)

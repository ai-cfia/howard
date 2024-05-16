# ADR-016 : Réseautique

## Résumé exécutif

Cette décision d'architecture vise à formaliser la stratégie de réseautique pour
nos applications déployées sur Kubernetes, en évaluant les composants actuels et
futures d'accès réseau pour maximiser performance, sécurité et facilité de
gestion. Nous utilisons Azure pour cette architecture, en intégrant ingress
Nginx, cert-manager, vouch-proxy, ainsi qu'une gestion automatique des
enregistrements DNS grâce à external-dns.

## Contexte

Dans notre architecture Kubernetes actuelle, nous utilisons ingress Nginx pour
le contrôle d'accès, géré par une IP statique attribuée par Azure.
Nous automatisons la création des enregistrements CNAME pour nos services
via external-dns, ce qui facilite significativement la gestion des DNS.
En outre, cert-manager est déployé pour la gestion automatique des certificats
SSL, sécurisant ainsi les communications, tandis que vouch-proxy gère l'accès
sécurisé aux applications. Notre domaine `.inspection.alpha.canada.ca` est géré
dans une zone DNS sur Azure, bénéficiant d'une intégration directe
avec ces services.

## Décision

Nous recommandons de maintenir l'utilisation de Nginx Ingress, cert-manager,
et vouch-proxy, en combinant ces services avec la gestion DNS automatisée
par external-dns. Cette configuration nous offre robustesse,
souplesse et sécurité, en harmonie avec les services d'Azure.

## Alternatives Considérées

### Istio Ingress

Avantages:

- **Intégration des services mesh:** Offre une gestion avancée du routage,
de l’équilibrage de charge, et des politiques de sécurité à l'échelle des
services.

- **Granularité des politiques réseau:** Permet une gestion détaillée des
politiques réseau entre services.

Inconvénients:

- **Complexité:** Sa configuration et sa gestion sont complexes et peuvent
représenter un défi en termes de maintenance.

- **Consommation de ressources:** Istio est plus gourmand en ressources, ce
qui peut être problématique dans des environnements à capacité limitée.

### Kubernetes Gateway API

Avantages:

- **Standard en évolution:** Propose un modèle plus expressif que les Ingress
traditionnels avec une meilleure abstraction pour les routes.

- **Modularité et flexibilité:** Offre une forte personnalisation dans la
gestion du trafic et des routes.

Inconvénients:

- **Maturité et adoption:** Étant donné sa nouveauté, l'adoption du Gateway API
n’est pas encore généralisée et pourrait manquer de support comparé
à des solutions établies.

- **Redondance possible:** Certaines capacités peuvent chevaucher celles
fournies par Nginx Ingress, nécessitant potentiellement une réévaluation
des outils en place.

## Conclusion

La configuration actuelle utilisant Nginx Ingress, cert-manager, vouch-proxy,
et external-dns pour la gestion automatique des enregistrements DNS fournit
un équilibre optimal entre efficacité, sécurité et gestion simplifiée dans notre
environnement Azure. Ces choix appuient notre stratégie de maintenir une
architecture stable tout en exploitant au maximum les compétences et les
technologies que nous maîtrisons déjà. Continuer sur cette voie nous permet
de bénéficier d'une intégration et d'un support solides par Azure, tout en
facilitant la scalabilité et la maintenance de nos services de réseautique.

## Références

- [Implementation dans Howard](
https://github.com/ai-cfia/howard/blob/main/docs/networking.md)
- [Implementation de Vouch proxy dans Howard](
https://github.com/ai-cfia/howard/blob/main/docs/auth-workflow.md)
- [Istio ingress](
https://istio.io/latest/docs/tasks/traffic-management/ingress/)
- [Kubernetes gateway api](https://gateway-api.sigs.k8s.io/)
- [Ingress NGINX](https://docs.nginx.com/nginx-ingress-controller/)
- [Cert manager](https://cert-manager.io/)
- [External DNS](https://github.com/kubernetes-sigs/external-dns)

# ADR-015 : Gestion d'authentification des utilisateurs

## Résumé Exécutif

Dans le cadre de la gestion centralisée de l'authentification des utilisateurs
pour nos applications, notamment l'application Nachet, nous avons choisi
d'implémenter Vouch-proxy. Cette solution a été sélectionnée pour sa capacité à
intégrer de manière efficace les services d'authentification tels qu'Azure et
Github, tout en récupérant les informations de groupe des utilisateurs dans un
token. Vouch-proxy nous permet d'appliquer une gestion d'authentification
uniforme et sécurisée pour tous les services hébergés sur notre cluster
Kubernetes, grâce à son intégration avec l'ingress NGINX. Ce choix vise à
améliorer la sécurité tout en offrant une flexibilité et une évolutivité accrues
pour nos opérations de gestion d'identité et d'accès.

## Contexte

Certaines de nos applications, dont l'application Nachet, requièrent une
authentification pour accéder à leurs services. Initialement, Nachet a été
déployée sans mécanismes d'authentification, permettant ainsi à n'importe quel
utilisateur de consulter la page et potentiellement d'y insérer des images
malveillantes. Face à cette vulnérabilité, et afin de sécuriser l'accès à
l'ensemble des applications sur notre cluster Kubernetes, il est devenu
impératif d'adopter une solution d'authentification centralisée. Cette solution
doit également être capable de s'intégrer avec les fournisseurs d'identité tels
que Azure et Github, et de récupérer les groupes d'utilisateurs dans un token
pour une gestion fine des autorisations.

## Décision

Après avoir évalué plusieurs alternatives, nous avons opté pour l'utilisation de
Vouch-proxy pour répondre à nos besoins d'authentification centralisée.
Vouch-proxy se distingue par sa compatibilité avec les fournisseurs d'identité
Azure et Github, facilitant ainsi l'authentification des utilisateurs tout en
récupérant les informations essentielles des groupes dans un token. Cette
capacité nous est cruciale pour la gestion des autorisations au sein de nos
services. En outre, Vouch-proxy s'intègre parfaitement à l'ingress NGINX de
notre cluster Kubernetes, permettant une gestion centralisée de
l'authentification pour tous nos services. Cette approche centralisée garantit
une sécurité renforcée et une meilleure cohérence dans la gestion des accès
utilisateurs à travers différentes applications.

## Alternatives Considérées

### Ori network (Ori Oathkeeper, Ori Kratos)

Avantages :

- Ori Oathkeeper est un proxy d'authentification et d'autorisation qui peut être
  utilisé pour gérer l'authentification des utilisateurs et des services de
  facons centralisée. Ori Kratos est un service d'identité et d'accès qui peut
  être utilisé pour gérer les utilisateurs et les rôles de manière centralisée.
  L'avantage de ces solutions est qu'elles peuvent être utilisées comme solution
  complète pour gérer l'authentification et l'autorisation des utilisateurs et
  des services.

Inconvénients :

- Ori Oathkeeper et Ori Kratos sont des solutions relativement nouvelles et se
  sont avérées moins matures que d'autres solutions d'authentification. Nous
  avons essayer un déploiement de Kratos et avons rencontré des problèmes de
  configuration entre autres. La documentation est également moins complète que
  celle d'autres solutions.

### Oauth2-Proxy

Avantages :

- Oauth2-Proxy est un proxy d'authentification qui peut être utilisé pour gérer
  l'authentification des utilisateurs et peut être configuré avec le ingress
  NGINX.

Inconvénients :

- Oauth2-Proxy est configurable pour gérer l'authentification 1 pour 1, mais
  n'est pas conçu pour gérer l'authentification de manière centralisée pour
  plusieurs services. Vouch-proxy est une alternative plus adaptée à nos besoins
  de gestion d'authentification centralisée.

### Solution sur mesure pour l'authentification

Avantages :

- Adaptation précise : Une solution sur mesure offre la possibilité de
  développer un système d'authentification qui correspond précisément aux
  exigences spécifiques de notre infrastructure et de nos applications. Cela
  permet une intégration plus fine et adaptée aux processus internes.
- Contrôle complet : En concevant notre propre solution, nous bénéficions d'un
  contrôle total sur les aspects de sécurité et de fonctionnalité, nous
  permettant ainsi d'ajuster ou d'améliorer la solution en fonction des
  évolutions des besoins de sécurité et de gestion des utilisateurs.

Inconvénients :

- Coût et temps de développement élevés : La conception d'une solution
  personnalisée exige un investissement initial significatif en temps et en
  ressources humaines.
- Maintenance et mise à jour : Les coûts opérationnels post-développement
  peuvent être importants, incluant la maintenance régulière et les mises à jour
  nécessaires pour répondre aux nouvelles menaces de sécurité et aux exigences
  légales.
- Compétitivité et maturité : Il est difficile pour une solution interne de
  rivaliser avec les fonctionnalités et la sécurité offertes par des solutions
  éprouvées sur le marché, qui bénéficient d'un développement continu et du
  retour d'expérience d'une large base d'utilisateurs.

## Conséquences

L'adoption de Vouch-proxy pour l'authentification centralisée au sein de notre
infrastructure présente des implications significatives, tant positives que
négatives. Sur le plan positif, cette décision renforcera la sécurité de nos
applications en intégrant efficacement des services d'authentification robustes
tels qu'Azure et Github, tout en facilitant la gestion des droits d'accès grâce
à la récupération des groupes d'utilisateurs dans un token. Cela simplifiera
également l'administration de nos systèmes et améliorera la cohérence de
l'expérience utilisateur à travers différentes applications. Toutefois, il est
essentiel de reconnaître que cette mise en œuvre nécessitera des ajustements
techniques, notamment dans la configuration et le maintien de l'ingress NGINX,
et pourrait introduire une complexité initiale lors de la phase d'intégration.
De plus, cette décision engage l'entreprise à dépendre de la pérennité et de
l'évolution de Vouch-proxy, ainsi que de la stabilité de ses intégrations avec
les fournisseurs d'identité. Il sera donc crucial de suivre de près ces aspects
et de prévoir des plans d'action pour les mises à jour nécessaires et les
éventuels ajustements en réponse aux défis qui pourraient survenir.

## Références

- [Oauth2-Proxy](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Vouch-proxy](https://github.com/vouch/vouch-proxy)
- [Ori Oathkeeper](https://www.ory.sh/oathkeeper/)
- [Ori Kratos](https://www.ory.sh/kratos/)
- [Example of implementing authentication with Express Web
  app](https://learn.microsoft.com/en-us/entra/identity-platform/tutorial-v2-nodejs-webapp-msal)

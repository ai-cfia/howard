# Workflow des métriques GitHub

Ce document fournit un aperçu du workflow des métriques GitHub, y compris son
objectif, sa fonctionnalité, et ses directives d'utilisation. Ce workflow est
conçu pour générer un rapport de métriques GitHub sur une période de dates
spécifiée.

## Workflow : Générer un rapport de métriques GitHub

### Objectif

Le workflow automatise le processus de génération d'un rapport de métriques
pour des dépôts et membres GitHub sélectionnés sur une période spécifiée.
Le rapport généré est téléchargé en tant qu'artifact PDF.

### Déclencheur

Le workflow est exécuté manuellement via `workflow_dispatch`, qui nécessite
des entrées spécifiques :

- **start_date** (string) : Le début de la plage de dates pour le rapport
(format : yyyy-mm-dd).
- **end_date** (string) : La fin de la plage de dates pour le rapport
(format : yyyy-mm-dd).
- **selected_members** (string) : Liste des membres GitHub à inclure dans le
rapport, séparée par des virgules. Par défaut, '*' (tous les membres).
- **selected_repositories** (string) : Liste des dépôts à inclure dans le
rapport, séparée par des virgules. Par défaut, '*' (tous les dépôts).

### Étapes

1. **Générer un token depuis l'application GitHub** :
   - Utilise une application GitHub pour créer un token d'authentification
   pour accéder aux données des métriques.

2. **Cloner le dépôt** :
   - Clone le dépôt courant sur le runner du workflow.

3. **Configurer l'environnement Python** :
   - Configure l'environnement Python avec la version 3.8 pour exécuter
   le script des métriques.

4. **Installer un package personnalisé** :
   - Installe un package depuis GitHub contenant les scripts nécessaires pour
   l'extraction des métriques.

5. **Accéder aux site-packages utilisateur** :
   - Détermine le chemin vers le répertoire site-packages de Python pour
   les scripts installés.

6. **Installer les dépendances** :
   - Installe les dépendances supplémentaires listées dans `requirements.txt`.

7. **Exécuter le script des métriques GitHub** :
   - Exécute le script des métriques en utilisant des variables d'environnement
   configurées avec les entrées fournies.

8. **Télécharger l'artifact PDF** :
   - Télécharge le rapport PDF généré en tant qu'artifact, en le nommant en
   fonction de la plage de dates spécifiée.

### Configuration

#### Variables d'environnement

- **GITHUB_ACCESS_TOKEN** : Token généré pour accéder aux données GitHub.
- **START_DATE** : Entrée de la date de début pour le rapport.
- **END_DATE** : Entrée de la date de fin pour le rapport.
- **SELECTED_REPOSITORIES** : Dépôts spécifiés pour l'extraction des métriques.
- **SELECTED_MEMBERS** : Membres spécifiés pour l'extraction des métriques.

### Utilisation

Pour utiliser ce workflow :

- Déclenchez-le manuellement depuis l'onglet GitHub Actions.
- Fournissez les entrées requises (`start_date`, `end_date`) et personnalisez
les entrées optionnelles (`selected_members`, `selected_repositories`)
selon vos besoins.

### Remarques

- Assurez-vous que les secrets `GH_WORKFLOW_APP_ID`, `GH_WORKFLOW_APP_PEM`,
`DEVOPS_USER`, et `DEVOPS_USER_TOKEN` sont correctement configurés dans les
paramètres du dépôt pour une authentification sécurisée.
- Le workflow dépend de scripts Python hébergés dans un dépôt, qui doivent
être accessibles au workflow par le biais de permissions appropriées.

### Liens

<https://github.com/ai-cfia/devops/blob/main/.github/workflows/github-metrics-workflow.yml>

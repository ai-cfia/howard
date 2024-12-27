# Workflow de détection de fuites de secrets et gestion des tokens github

Ce document fournit une vue d'ensemble du workflow de détection des fuites de
secrets, en détaillant son objectif, sa fonctionnalité, et ses directives
d'utilisation. Ce workflow est conçu pour identifier toute fuite potentielle
de secrets dans le code source des dépôts.

## Workflow : Détection des fuites de secrets

### Objectif

Le workflow automatise le processus de détection des secrets potentiellement
exposés dans le dépôt via une analyse rigoureuse du code. Il utilise des outils
pour authentifier et récupérer des secrets sécurisés depuis un gestionnaire de
secrets avant l'analyse.

### Déclencheur

Le workflow est déclenché à chaque `push` sur n'importe quelle branche et
peut être appelé via `workflow_call`.

### Étapes

1. **Cloner le code** :
   - Utilise `actions/checkout@v3` pour cloner le code source du dépôt sur
   l'environnement de travail du runner.

2. **Authentifier et récupérer les secrets depuis Vault** :
   - Utilise l'action `hashicorp/vault-action@v3.0.0` pour s'authentifier
   auprès de Vault grâce à GitHub OIDC et récupérer les secrets nécessaires.

   Pour ajouter de nouveaux chemins aux secrets, tels qu'un répertoire pour
   `nachet`, ajoutez simplement une nouvelle ligne dans la configuration
   des secrets :

   ```yaml
   secrets: |
     kv/data/test * | VAULTACTIONKEY_;
     kv/data/nachet * | VAULTACTIONKEY_;
    ```

3. **Installer git-secrets** :
    - Installe l'outil git-secrets pour faciliter la détection des
    secrets dans le code.

4. **Ajouter des clés API à git-secrets** :
    - Ajoute les clés API récupérées à git-secrets pour être utilisées
    comme modèles dans l'analyse.

5. **Analyser le Dépôt pour détecter des Secrets** :
    - Exécute une analyse du dépôt à la recherche de secrets exposés
    en utilisant git-secrets.

6. **Supprimer les Modèles de git-secrets** :
    - Nettoie les configurations de git-secrets après l'analyse en supprimant
    les sections de configuration.

## Gestions des tokens github

Cette section documente les secrets utilisés dans tous nos workflows GitHub et
cluster.

- **VAULT_TOKEN** : <https://developer.hashicorp.com/vault/docs/auth/github>
- **GH_WORKFLOW_APP_ID** et **GH_WORKFLOW_APP_PEM** : Voir les informations sur
l'application github `GH app for workflows`.
- **DEVOPS_USER** et **DEVOPS_USER_TOKEN** : Doit avoir les permissions
necessaires pour ce que le `github-metrics` workflow demande.

### Utilisation

Pour utiliser ce workflow :

- Laissez-le s'exécuter automatiquement à chaque push sur les branches, ou
appelez-le manuellement selon les besoins via workflow_call.
- Assurez-vous que les secrets nécessaires sont correctement configurés dans
les paramètres du dépôt.

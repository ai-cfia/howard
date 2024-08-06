
# Créer une release et étiqueter une pull request

Ce document explique l'objectif, le fonctionnement et l'utilisation des deux
workflows GitHub fournis. Les workflows automatisent le processus de création
de releases et d'étiquetage des pull requests.

## Workflow (1) : Créer une release, construire et pousser sur GHCR avec un tag spécifique

### Objectif (1)

Ce workflow automatise les étapes suivantes :

- **Créer une release GitHub :** Il génère une release basée sur un tag
poussé dans le dépôt.
- **Générer un changelog :** Il utilise les étiquettes des pull requests
fusionnées pour générer un changelog.
- **Construire et pousser une image Docker :** Il construit une image Docker et
la pousse sur le GitHub Container Registry (GHCR).

### Déclencheur (1)

Le workflow est déclenché manuellement via `workflow_call` avec deux entrées
requises :

- `artifact-name` : Nom de l'artifact à créer.
- `registry` : Registre où l'image Docker sera poussée.

Dans la majorité des cas, le `workflow_call` se fait comme suit :

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
```

### Étapes (1)

- **Cloner le dépôt :** Clone le dépôt.
- **Extraire le nom du tag :** Extrait le nom du tag actuel à partir de la
référence GitHub.
- **Générer le changelog :** Génère un changelog en utilisant les pull requests
fusionnées.
- **Créer une release :** Crée une release GitHub en utilisant le tag extrait
et le changelog généré.
- **Télécharger l'asset de la release :** Compresse le dépôt et le télécharge
en tant qu'asset de la release.
- **Configurer Docker Buildx :** Configure Docker Buildx pour construire des
images multiplateformes.
- **Se connecter à GHCR :** Se connecte au GitHub Container Registry.
- **Mettre en cache les couches Docker :** Met en cache les couches Docker pour
accélérer le processus de build.
- **Construire et pousser l'image Docker :** Construit et pousse l'image Docker
sur GHCR.
- **Rafraîchir le cache :** Rafraîchit le cache Docker.
- **Afficher le digest de l'image :** Affiche le digest de l'image si
l'événement n'est pas une pull request fusionnée.

### Configuration (1)

L'étape de génération du changelog utilise l'action
`mikepenz/release-changelog-builder-action@v5` pour créer un changelog basé sur
les pull requests fusionnées depuis le tag précédent. Cette étape catégorise
les pull requests en différentes sections en fonction de leurs étiquettes.

```yaml
- name: Generate changelog
  id: changelog
  uses: mikepenz/release-changelog-builder-action@v5
  with:
    configurationJson: |
      {
          "categories": [
              {
                  "title": "## User stories 👑",
                  "labels": ["epic"]
              },
              {
                  "title": "## New features 🎉",
                  "labels": ["feature"]
              },
              {
                  "title": "## Bug fixes 🐛",
                  "labels": ["bug"]
              },
              {
                  "title": "## Documentation 📄",
                  "labels": ["documentation"]
              },
              {
                  "title": "## Other Changes 💬",
                  "labels": ["*"]
              }
          ],
          "template": "#{{CHANGELOG}}\n\nContributors:\n#{{CONTRIBUTORS}}",
          "max_pull_requests": 1000,
          "max_back_track_time_days": 1000
      }
    owner: ${{ github.repository_owner }}
    repo: ${{ github.event.repository.name }}
    toTag: ${{ env.TAG_NAME }}
    token: ${{ secrets.GITHUB_TOKEN }}
```

#### Explication (1)

- **Categories :** Définit les sections du changelog, chacune avec un titre
et des étiquettes associées. Les pull requests sont regroupées sous ces sections
en fonction de leurs étiquettes.
- **Histoires d'utilisateurs :** Inclut les pull requests étiquetées epic.
- **Nouvelles fonctionnalités :** Inclut les pull requests étiquetées feature.
- **Corrections de bugs :** Inclut les pull requests étiquetées bug.
- **Documentation :** Inclut les pull requests étiquetées documentation.
- **Autres changements :** Inclut les pull requests étiquetées avec d'autres
étiquettes.
- **template :** Définit le format du changelog.
- **max_pull_requests :** Le nombre maximum de pull requests à inclure dans
le changelog.
- **max_back_track_time_days :** Le nombre maximum de jours à remonter pour
les pull requests.

Lorsque le workflow est déclenché, cette étape compare le tag précédent avec le
nouveau tag et génère un changelog pour toutes les pull requests fusionnées
entre les deux tags. Chaque pull request est ajoutée à la section appropriée
en fonction de ses étiquettes.

### Utilisation (1)

Pour utiliser ce workflow, appelez-le depuis un autre workflow ou manuellement
avec les entrées requises. Par exemple :

```yaml
jobs:
  call-release-workflow:
    uses: your-repo/.github/workflows/create-release.yml
    with:
      artifact-name: my-artifact
      registry: ghcr.io/my-org
```

**Assurez-vous qu'un tag est poussé dans le dépôt pour déclencher la création de la release.**

## Workflow (2) : Étiqueteur de pull requests

### Objectif (2)

Ce workflow étiquette automatiquement les pull requests en fonction de leur nom
de branche ou des fichiers modifiés. Il utilise un fichier de configuration
pour déterminer les étiquettes à appliquer.

### Déclencheur (2)

Le workflow est déclenché manuellement via `workflow_call`.

### Étapes (2)

- Cloner le dépôt : Clone le dépôt contenant le fichier de configuration
`labeler.yml`.
- Étiqueter la pull request : Utilise l'action `actions/labeler` pour appliquer
des étiquettes à la pull request en fonction de la configuration.

### Configuration (2)

Le fichier `labeler.yml` définit les règles pour étiqueter les pull requests :

```yaml
documentation:
  - any:
    - changed-files:
      - any-glob-to-any-file:
        - 'docs/**'
        - '**/*.md'

tests:
  - any:
    - changed-files:
      - any-glob-to-any-file: tests/**

feature:
  - head-branch: ['^feature', 'feature', '^feat', 'feat']

bug:
  - head-branch: ['^bug', 'bug', '^fix', 'fix']

epic:
  - head-branch: ['^epic', 'epic']
```

### Utilisation (2)

- Une pull request avec le nom de branche `feature/new-feature` sera étiquetée
comme **feature**.
- Une pull request modifiant des fichiers dans le répertoire `docs/` sera
étiquetée comme **documentation**.
- Une pull request avec le nom de branche `bug/fix-issue` sera étiquetée
comme **bug**.
- Une pull request avec le nom de branche `epic/new-epic` sera étiquetée
comme **epic**.

En utilisant ces workflows, vous pouvez simplifier le processus de gestion des
releases et de l'étiquetage des pull requests dans votre dépôt.

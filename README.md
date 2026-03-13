# bash-deploy-pipeline

![Shell](https://img.shields.io/badge/Shell-Bash-green) ![Status](https://img.shields.io/badge/Status-Active-brightgreen) ![License](https://img.shields.io/badge/License-MIT-yellow) ![Platform](https://img.shields.io/badge/Platform-Linux-blue)

Pipeline de déploiement simulé en Bash — automatise les étapes build, test, deploy, rollback et logging d'une application web statique.

---

## Description

Ce projet implémente un pipeline de déploiement complet en Bash, conçu pour automatiser le cycle de vie d'une application web statique. Il simule un environnement multi-cibles (local, staging, prod) et intègre des Git hooks pour garantir la qualité du code à chaque commit et push.

> **Note** : Le déploiement est simulé localement via des dossiers. L'architecture est conçue pour être adaptée à un déploiement réel via `scp`, `rsync` ou `aws s3 sync`.

---

## Architecture

```
bash-deploy-pipeline/
├── app/                        # Application source
│   ├── index.html              # Version propre v1.0.0
│   ├── index_broken.html       # Version avec défauts (tests échouent)
│   ├── index_rollback.html     # Version v2.0.0 CSS cassé (rollback)
│   └── style.css
├── build/                      # Fichiers buildés (généré automatiquement)
├── deploy/                     # Environnements de déploiement
│   ├── local/
│   ├── staging/
│   └── prod/
├── hooks/                      # Git hooks versionnés
│   ├── pre-commit
│   └── pre-push
├── logs/                       # Historique des déploiements
│   └── deploy.log
├── scripts/                    # Scripts du pipeline
│   ├── pipeline.sh             # Point d'entrée principal
│   ├── build.sh                # Étape de build
│   ├── test.sh                 # Étape de test
│   ├── deploy.sh               # Étape de déploiement
│   ├── rollback.sh             # Rollback vers la version précédente
│   └── logs.sh                 # Affichage de l'historique
└── .gitignore
```

---

## Prérequis

- Linux / macOS
- Bash 4+
- Git

---

## Installation

```bash
# Cloner le repo
git clone git@github.com:AmauryA406/bash-deploy-pipeline.git
cd bash-deploy-pipeline

# Installer les Git hooks
cp hooks/pre-commit .git/hooks/pre-commit
cp hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/pre-push

# Rendre les scripts exécutables
chmod +x scripts/*.sh
```

---

## Usage

Toutes les commandes se lancent depuis la racine du projet via `pipeline.sh`.

```bash
# Build — prépare l'app dans build/
./scripts/pipeline.sh build

# Test — vérifie la qualité du build
./scripts/pipeline.sh test

# Deploy — déploie vers un environnement cible
./scripts/pipeline.sh deploy local
./scripts/pipeline.sh deploy staging
./scripts/pipeline.sh deploy prod

# Rollback — restaure la version précédente
./scripts/pipeline.sh rollback local

# Logs — affiche l'historique des déploiements
./scripts/pipeline.sh logs
```

---

## Ce que vérifie test.sh

| Test | Description |
|------|-------------|
| Fichier présent | `build/index.html` existe |
| Commentaire VERSION | Le marqueur `VERSION` est présent dans le HTML |
| Numéro de version | Le champ `id="version"` n'est pas vide |
| Balises div | Nombre de `<div>` égal au nombre de `</div>` |
| Fichiers CSS | Tous les fichiers CSS référencés existent dans `app/` |

---

## Scénarios de démonstration

### Scénario 1 — Pipeline nominal ✅

```bash
./scripts/pipeline.sh build
./scripts/pipeline.sh test
./scripts/pipeline.sh deploy local
./scripts/pipeline.sh logs
```

### Scénario 2 — Pipeline bloqué par les tests ❌

```bash
# Remplacer index.html par la version cassée
mv app/index.html app/index_save.html
mv app/index_broken.html app/index.html

./scripts/pipeline.sh build
./scripts/pipeline.sh test
# → Erreurs détectées, déploiement bloqué

# Restaurer
mv app/index.html app/index_broken.html
mv app/index_save.html app/index.html
```

### Scénario 3 — Déploiement + Rollback ↩️

```bash
# Deploy v1.0.0
./scripts/pipeline.sh build && ./scripts/pipeline.sh test && ./scripts/pipeline.sh deploy local

# Deploy v2.0.0 (CSS cassé mais tests passent)
mv app/index.html app/index_v1.html
mv app/index_rollback.html app/index.html
./scripts/pipeline.sh build && ./scripts/pipeline.sh test && ./scripts/pipeline.sh deploy local

# L'app est cassée visuellement → rollback
./scripts/pipeline.sh rollback local
./scripts/pipeline.sh logs
```

---

## Git Hooks

Les hooks bloquent automatiquement les opérations Git si le pipeline échoue.

| Hook | Déclencheur | Action |
|------|-------------|--------|
| `pre-commit` | `git commit` | Lance `test.sh` — bloque si tests échouent |
| `pre-push` | `git push` | Lance `build.sh` + `test.sh` — bloque si échec |

---

## Concepts couverts

- Scripting Bash avancé (fonctions, conditions, boucles, gestion d'erreurs)
- Manipulation de fichiers Linux (`cp`, `mv`, `rm`, `grep`, `sed`, `find`)
- Gestion des codes de retour (`$?`, `exit 0/1`)
- Git hooks (`pre-commit`, `pre-push`)
- Logging et traçabilité
- Architecture pipeline (build → test → deploy → rollback)

---

## Licence

MIT

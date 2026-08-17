<!-- omit in toc -->
# MICROBIOME-MASTER ITS

[![FR](https://img.shields.io/badge/lang-FR-yellow.svg)](README_FR.md)
[![EN](https://img.shields.io/badge/lang-EN-blue.svg)](README.md)

---

<!-- omit in toc -->
## Table des matières

- [À propos](#à-propos)
- [Documentation](#documentation)
- [Citation](#citation)
- [Contribution](#contribution)
- [Sécurité](#sécurité)
- [Licence](#licence)

---

## À propos

Le pipeline **Microbiome-Master ITS** est un pipeline léger et construit sur mesure pour le traitement bioinformatique de routine des amplicons bruts de la région du gène ITS en **variantes de séquence d’amplicons (ASV)**. Le pipeline est géré via [snakemake](https://snakemake.readthedocs.io/en/stable/) et utilise une variété de flux de travail standard d’analyse de données basés sur le microbiome, notamment [QIIME2](https://qiime2.org/), [dada2](https://benjjneb.github.io/dada2/), etc. Le pipeline est spécifiquement conçu pour traiter les lectures d’extrémité appariées basées sur Illumina, mais d’autres données d’entrée à lecture courte peuvent être utilisées (par exemple, Ion Torrent; contacter le mainteneur *(voir [CREDITS.md](CREDITS.md))* pour plus d’informations).

À partir d’un fichier de cartographie au format QIIME2 (reliant les noms des fichiers de séquençage aux ID d’échantillons et aux métadonnées) et de fichiers .fastq démultiplexés bruts (non compressés ou compressés), le pipeline effectuera à la fois le nettoyage des séquences (c’est-à-dire le filtrage des bases de mauvaise qualité, le retrait des amorces, la vérification des chimères, etc.) et la visualisation des bases et les analyses statistiques (c’est-à-dire les ordinations, les diagrammes à barres des taxons, les courbes de raréfaction, etc.); la plupart de ces éléments (fichiers .qza/.qzv en particulier) peuvent être visualisés directement à l’aide de [qiime2-vue](https://view.qiime2.org/).

Le pipeline est construit à l’aide de modules de flux de travail qui permettent aux utilisateurs de spécifier le type d’analyse qu’ils souhaitent exécuter (c’est-à-dire un flux de travail de routine). La modularité du pipeline permet une intégration facile de nouveaux flux de travail. Les flux de travail actuellement pris en charge sont les suivants:

**MODULE QIIME2-DADA2:**
- Génération de tables ASV à l’aide de la version de DADA2 implémentée dans QIIME2 et analyses générales

**MODULE GRDI LEGACY:**
- Pipeline d’analyse basé sur les OTU, désormais utilisé pour assurer la compatibilité rétroactive. Ce module est archivé à des fins historiques **[PLUS PRIS EN CHARGE]**.

---

## Documentation

Pour les détails techniques, y compris les instructions d’installation et d’utilisation, veuillez consulter le **[Guide de l’utilisateur](/docs/user-guide.md)**.

---

## Citation

Pour citer ce projet, cliquez sur le bouton **`Cite this repository`** dans la barre latérale de droite.

---

## Contributors

*Ce projet a été élaboré par le **Groupe d’écologie microbienne (AAC-Harrow)**. Pour une liste des contributions individuelles, voir **[CREDITS.md](CREDITS.md)**.*

- Les fichiers suivants ont été adaptés à partir du [Template for Government of Canada open source code repositories](https://github.com/canada-ca/template-gabarit): `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` et `SECURITY.md`.
- Les contributions sont les bienvenues!! Veuillez consulter les lignes directrices dans [CONTRIBUTING.md](CONTRIBUTING.md) et vous assurer de respecter notre [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) pour favoriser un -
- Pour une liste des ressources clés utilisées ici, voir [REFERENCES.md](REFERENCES.md).

---

## Sécurité

⚠️ Ne publiez aucun problème de sécurité sur le répertoire public ! Veuillez les signaler comme décrit dans [SECURITY.md](SECURITY.md).

---

## Licence

> Voir le fichier [LICENSE](LICENSE) pour plus de détails. Visitez [LicenseHub](https://licensehub.org/fr) ou [tl;drLegal](https://www.tldrlegal.com/) pour consulter un résumé en langage clair de cette licence.

**Droit d’auteur ©** Sa Majesté le Roi du chef du Canada, représenté par le ministre de l’Agriculture et de l’Agroalimentaire, 2026.

---

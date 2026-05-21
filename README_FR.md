<!-- omit in toc -->
# MICROBIOME-MASTER ITS

[![FR](https://img.shields.io/badge/lang-FR-yellow.svg)](README_FR.md)
[![EN](https://img.shields.io/badge/lang-EN-blue.svg)](README.md)

---

<!-- omit in toc -->
## Table des matières

- [À propos](#à-propos)
- [Documentation](#documentation)
- [Acknowledgements](#acknowledgements)
- [Sécurité](#sécurité)
- [Licence](#licence)

---

## À propos

Le pipeline **Microbiome-Master ITS** est un pipeline léger, développé sur mesure pour le traitement bioinformatique de routine des amplicons bruts de la région génique ITS en **variants de séquences d’amplicons (ASV)**. Le pipeline est géré via [snakemake](https://snakemake.readthedocs.io/en/stable/) et utilise divers flux de travail standards d’analyse de données microbiomiques, notamment [QIIME2](https://qiime2.org/), [dada2](https://benjjneb.github.io/dada2/), etc. Le pipeline est spécialement conçu pour traiter des lectures paired-end basées sur Illumina, mais d’autres données de séquençage à lectures courtes peuvent également être utilisées (par ex. Ion Torrent; contacter le responsable du projet *(see [CREDITS.md](CREDITS.md))* pour plus d’informations).

À partir d’un fichier de correspondance au format QIIME2 (associant les noms des fichiers de séquençage aux identifiants d’échantillons et aux métadonnées) et de fichiers .fastq bruts démultiplexés (compressés ou non), le pipeline effectue à la fois le nettoyage des séquences (c.-à-d. filtrage des bases de faible qualité, suppression des amorces, détection des chimères, etc.) ainsi que des analyses de visualisation et statistiques de base (c.-à-d. ordinations, graphiques en barres des taxons, courbes de raréfaction, etc.; la plupart de ces fichiers (.qza/.qzv en particulier) peuvent être visualisés directement avec [qiime2-view](https://view.qiime2.org/))).

Le pipeline est construit à l’aide de modules de workflow permettant aux utilisateurs de spécifier le type d’analyse qu’ils souhaitent exécuter (p. ex. workflow de routine, workflow PICRUSt2). La modularité du pipeline permet une intégration facile de nouveaux workflows. Les workflows actuellement pris en charge incluent:

**MODULE QIIME2-DADA2:**
- Génération de tables ASV à l’aide de la version de DADA2 implémentée dans QIIME2 et analyses générales

**MODULE GRDI LEGACY:**
- Pipeline d’analyse basé sur les OTU, désormais utilisé pour assurer la compatibilité rétroactive. Ce module est archivé à des fins historiques **[PLUS PRIS EN CHARGE]**.

---

## Documentation

Pour les détails techniques, y compris les instructions d’installation et d’utilisation, veuillez consulter le **[Guide de l’utilisateur](/docs/user-guide.md)**.

---

## Acknowledgements

---

## Sécurité

⚠️ Ne publiez aucun problème de sécurité sur le répertoire public ! Veuillez les signaler comme décrit dans [SECURITY.md](SECURITY.md).

---

## Licence

> Voir le fichier [LICENSE](LICENSE) pour plus de détails. Visitez [LicenseHub](https://licensehub.org/fr) ou [tl;drLegal](https://www.tldrlegal.com/) pour consulter un résumé en langage clair de cette licence.

**Droit d’auteur ©** Sa Majesté le Roi du chef du Canada, représenté par le ministre de l’Agriculture et de l’Agroalimentaire, 2026.

---

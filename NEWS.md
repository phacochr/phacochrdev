# phacochrdev 0.10.0.0

Date : 1er novembre 2024

## Précaution
Cette mise-à-jour nécessite de refaire un `phaco_setup_data()` avant de pouvoir faire un `phaco_best_data_update()`. Pour être sûr faites dans l’ordre :
```r
library(devtools)
devtools::install_github("phacochr/phacochr")
library(phacochr)
phaco_setup_data()
phaco_best_data_update()
```

## ID BeST
Désormais, les id BeST sont repris dans le résultat:
best_address_id : L’id adresse tel qu’il est repris dans BeST Address (dans les données BeST Address, le champ s'appelle address_id). Cet id est issu des fournisseurs régionaux (Urbis, CRAB et ICAR), dès lors plusieurs rues ont des id similaires entre les différentes régions. Pour le rendre unique nous avons ajouté les préfixes bru, wal, et vlg.
best_street_id : L’id de la rue tel qu’il est repris dans BeST Address (dans les données BeST Address, le champ s'appelle street_no ou street_id).
best_postal_code: le code postal tel que dans BeST.

## Anciens noms de rue à Charleroi
La base de données d'adresse de référence (BeST) a été enrichie avec les anciens noms de rue de la commune de Charleroi. La commune a changé les noms de 250 rues pour éviter les homonymes. On a rajouté ces noms de rues parce qu’ils sont encore sûrement présents dans beaucoup de base de données. https://www.charleroi.be/vie-communale/publications/nouveaux-noms-de-rues

## Quartiers monitoring
Rectification pour deux secteurs statistiques étaient attribués à un mauvais quartier monitoring à Bruxelles lors de la jointure spatiale entre les quartiers avec les centroïdes des secteurs statistiques. Le centroide est maintenant réalisé grâce à st_point_on_surface et non plus avec st_centroid pour s’assurer que le centroïde est bien dans le polygone.

## Changement de nom de champ en sortie
-   phaco_id_address remplace ID_adress pour insister sur le fait qu’il s’agit d’un id créé par phacochr
-   street_detected remplace street_FINAL_detected et langue_detected remplace langue_FINAL_detected pour plus de simplicité

## Nouvelle fonction pour charger les données
Une nouvelle la fonction `phaco_data()` a été rajoutée pour charger les données utilisées par phacochr et stockées sur l’ordinateur:
-  rues (les rues BeST prétaitées pour l'usage de phacochr)
-  adresses (les adresses BeST  prétaitées pour l'usage de phacochr)
-  sec (les secteurs statistiques)
-  communes_bel (les communes de Belgiques)
-  provinces (les provinces de Belgiques)
-  regions (les régions de Belgiques)
-  belgique (les limites de la Belgique)
-  rbc (la Région de Bruxelles-Capitale)
-  communes_bxl (les communes de la Région de Bruxelles-Capitale)
-  quartiers_bxl (les quartiers monitoring de Bruxelles)
-  rbc (les limites de la Région de Bruxelles-Capitale)
-  sec_bxl (les secteurs statistiques de la Région des Bruxelles-Capitale)

## Ajout paramètre error_max_elag

Dans `phaco_geocode()`, le paramètre error_max_elag est ajouté pour pouvoir déterminer le nombre d'erreurs autorisées lors de l'élargissement aux codes postaux de la communes et aux codes postaux des communes adjacentes. Dans les versions précédentes ce paramètres était fixé à la moitié du nombre d'erreurs autorisées si la rue était trouvée dans le code postal renseigné. Désormais, par défaut, seulement 2 erreurs sont autorisées comme dans les versions précédentes mais il est possible de personnaliser ce paramètre.


# phacochr 0.9.1.14

Date : 5 mai 2023

## Modifications majeures

-   Ajout d'une correction des rues BeSTAddress dans la fonction `phaco_best_data_update()`. L'option est activée par défaut, car le formatage des données BeST n'est pas homogène : on trouve parfois dans celles-ci des précisions entre parenthèses (notamment pour Charleroi), des abréviations (St. pour Saint, Av. pour Avenue), etc., ce qui nuit à la bonne détection des rues. L'option est désactivable via le nouvel argument `corrections_REGEX` de la fonction `phaco_best_data_update()`.

# phacochr 0.9.1.13

## Modifications mineures

-   Intégration au package du script `map_process.R` permettant de créer les géométries utilisées dans `phaco_map()` à partir des géométries des secteurs statistiques Statbel et des quartiers du monitoring Urbis (Bruxelles). Le script est situé dans le répertoire `inst/scripts` du package, et peut être appelé via la fonction `system.file()`. Par exemple, en exécutant la commande : `source(paste0(system.file("scripts", package = "phacochr"), "/map_process.R"))`. Le script est intégré par transparence des opérations effectuées, mais il ne semble pas utile d'en faire une fonction, la mise à jour des géométries n'étant pas une opération à réaliser régulièrement.

-   Modification dans la manière de créer les géométries des quartiers du monitoring (Bruxelles). Auparavant, les frontières des quartiers étaient issues du fichier Urbis installé avec le package. Désormais, les géométries des quartiers du monitoring reposent sur les géométries des secteurs statistiques de Stabel, par cohérence avec la manière dont la table *secteurs statistiques - quartiers du monitoring* est créée par la fonction `phaco_best_data_update()`. Ce changement n'a aucun impact sur le fonctionnement et les résultats de `phacochr`, car les géométries des quartiers du monitoring ne sont pas utilisées par les fonctions de `phacochr`. Cette modification modifie simplement le fichier vectoriel des quartiers du monitoring de Bruxelles disponible dans le répertoire d'installation de phacochr (le fichier `C:\Users\USERNAME\AppData\Local\phacochr\phacochr\data_phacochr\STATBEL\PREPROCESSED\BXL_quartiers_PREPROCESSED.gpkg` sous Windows). A terme, il sera utile de créer une fonction rendant facilement disponible ces fichiers pour l'utilisateur.

# phacochr 0.9.1.12

Début de la mise à jour régulière du fichier `NEWS.md` pour documenter les modifications de `phacochr`.

## Modifications mineures

-   Ajout de `ifelse()` pour l'exécution des corrections orthographiques dans la fonction `phaco_geocode()`. Le temps de calcul pour le géocodage diminue de +/- 1%.

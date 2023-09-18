# TP Fichiers locaux

**Objectif : découvrir le mode de fonctionnement de Terraform sans cloud** 

Avant de commencer, chercher à comprendre le contenu du fichier `main.tf`.

Cette recette est très simple et produit un seul objet, sans utiliser d'entrées et de sorties.

### 1. Lancer la recette en suivant le cycle 

- `terraform init` 
- `terraform plan` 
- `terraform apply`

En lançant une commande `$ find .` dans le dossier, quels fichiers sont apparus et que contiennent-ils ?


### 2. Modifier la recette ou les ressources en cours de route 

**Observer ce qui se passe en lançant `terraform plan` à chaque modification.**

- Déplacer la configuration du provider dans un fichier provider.tf 
- Modifier le contenu de l'attribut `content` de la ressource `local_file`  
- Quels autres attributs du `local_file` peut-on modifier ? Comment ? 
- Modifier le fichier `adam-douglas.txt` en local.

### 3. Terminer en lançant la destruction

. terraform destroy



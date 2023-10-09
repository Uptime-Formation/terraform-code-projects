# Soltion TP Fichiers locaux + random 

### 1. Lire la recette et chercher à comprendre son fonctionnement. 

- où est déclarée la variable `words` ? et où est déclaré son contenu ? 

> La variable est déclarée dans le fichier `main.tf`
> Son contenu est défini dans le fichier `terraform.tfvars`

- à quoi sert `num_files` et `count` ?

> `num_files` est une variable qui est utilisée pour définir le nombre de boucles à effectuer dans les ressources via le meta-argument `count` 

### 2. Lancer la recette 

- Que se passe-t-il ? 

> Des fichiers textes sont créés dans un dossier `madlibs` 

- Combien de ressources sont générées ? Pourquoi ?

> Il y a autant de fichiers que défini par la variables `num_files`
- Quelles propriété du provider `random` est évidente quand on demande un nouveau `plan` ?

### 3. Modifier et relancer la recette 

- Créer plusieurs fichiers avec le fichier unique `main.tf` 

> Ne produit pas de changement.

- Modifier la variable `num_files`

> Change le nombre de fichiers produits

- Modifier la variable `words` 

> Change le plan de la recette

- Modifier la fonction de transformation de `words` 

> Change le plan de la recette

- Ajouter le provider `hashicord_archive` et une ressource pour faire un fichier zip avec le dossier généré par la recette
```terraform

data "archive_file" "mad_libs" {
  depends_on  = [local_file.mad_libs] #A
  type        = "zip"
  source_dir  = "${path.module}/madlibs"  #C
  output_path = "${path.cwd}/madlibs.zip" #B
}
```

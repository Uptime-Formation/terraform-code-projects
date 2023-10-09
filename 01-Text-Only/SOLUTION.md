# Solution TP Fichiers locaux


### 1. Lancer la recette en suivant le cycle 

Fichiers sont apparus et que contiennent-ils ?

```terraform
# After terraform apply
$ find . -type f 

./terraform.tfstate
./.terraform.lock.hcl
./.terraform/providers/registry.terraform.io/hashicorp/local/2.4.0/linux_amd64/terraform-provider-local_v2.4.0_x5
./adam-douglas.txt

```

### 2. Modifier la recette ou les ressources en cours de route 

- Déplacer la configuration du provider dans un fichier provider.tf 

> Pas de changement

- Modifier le contenu de l'attribut `content` de la ressource `local_file`

> Le plan propose de **remplacer** la ressource.

- Quels autres attributs du `local_file` peut-on modifier ? Comment ?

> Ajouter des attributs à la ressource.
>       + directory_permission = "0777"
>       + file_permission      = "0777"



- Modifier le fichier `adam-douglas.txt` en local.

> Le plan propose de **recréer** la ressource.


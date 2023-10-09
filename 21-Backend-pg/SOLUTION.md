# Solution TP Recette backend PostgreSQL  

### 1. Suivre le README du provider pour créer le backend     

- Le fichier d'état terraform est-il créé ? 

> Non il n'y pas de fichier terraform.tfstate

- La planification tient-elle compte de l'état ? 

> Oui car elle prend en compte quand une commande `apply` est exécutée

- Que se passe-t-il si on coupe le service PostgreSQL ?

> Terraform renvoie une erreur.

- Comment voir ce qu'il y a dans la base ? Indice : pg_dump ou SELECT en tenant compte du schéma
```shell

$ docker exec docker-db-1 pg_dump -U terraform -W

```


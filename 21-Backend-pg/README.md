# TP Recette backend PostgreSQL  

**Objectif : Utiliser postgres comme solution de stockage backend**

L'objectif est de partager une recette à plusieurs 

### 1. Suivre le README du provider pour créer le backend     

- Suivre la démarche pour déployer une base de données PostgreSQL
- Lancer la recette avec le sous-bloc `backend` du bloc `terraform`
- Le fichier d'état terraform est-il créé ? 
- La planification tient-elle compte de l'état ? 
- Que se passe-t-il si on coupe le service PostgreSQL ? 
- Comment voir ce qu'il y a dans la base ? Indice : pg_dump ou SELECT en tenant compte du schéma

### 2. Aller plus loin

- Appliquer cette solution de backend à un des TPs précédents et observer le comportement.
- Faire la manipulation en binôme et tenter de faire des modifications depuis 2 postes
- Déployer une solution de backend pg pour un autre provider et/ou avec un objet cloud database  

### 3. Terminer en lançant la destruction

- `terraform destroy`


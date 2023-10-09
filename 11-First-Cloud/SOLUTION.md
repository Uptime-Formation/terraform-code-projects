# TP Solution Recette cloud basique 

### 1. Comparer les recettes 

- identifier le fonctionnement des différentes recettes 
- Comparer les providers 

> Les trois recettes ont des comportements proches:   
> . AWS est la plus simple   
> . Scaleway nécessite une ressource IP supplémentaire  
> . OVH propose de créer une clef SSH additionnelle pour se connecter

### 2. Choisir un provider et comprendre comment s'y connecter  

- Lire la documentation du provider et trouver les informations d'authentification 
- Fournir les informations d'authentification sous forme de variables d'environnement

```terraform
$ export ...
```

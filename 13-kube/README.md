# TP Recette k8S dans le cloud  

**Objectif : Une recette pour déployer kubernetes**

### 1. Choisir un provider et lancer la recette     

- lire la documentation du provider pour les ressources 
- identifier le fonctionnement des différentes composants 
- comparer les différentes solutions : éléments en plus ou en moins ?  

### 2. Se connecter au cluster Kubernetes

- Récupérer les informations d'authentification pour se connecter au cluster k8s 
- Des modifications de la recette sont-elles nécessaires pour ça ?
- Lancer un conteneur dans k8s avec
    ```
    kubectl run -i -t busybox --image=busybox --restart=Never
    ```

### 3. Modifier et tester la recette   

- Changer les paramètres du cluster, relancer apply
- Déployer un nouveau cluster avec un autre provider

### 4. Terminer en lançant la destruction

- `terraform destroy`


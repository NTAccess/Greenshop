# Greenshop
versions utilisées : Mariadb  : 10.6.21
// PHP :  8.1.2 -1ubuntu 2.21
// Apache2: 2.4.52
// OS Ubuntu: 22.04.5 LTS

# 🛒 Greenshop - Infrastructure as Code (IaC) sur AWS

## 📘 Description du projet

**Greenshop** est un projet complet d’infrastructure déployée sur AWS, conçu avec une approche *Infrastructure as Code* (IaC). Il combine **Terraform**, **Ansible**, **Docker** et **Jenkins** pour orchestrer le déploiement et la mise à jour d’une application web PHP connectée à une base de données **MariaDB**.

Ce projet est destiné à démontrer la mise en place automatisée d’une infrastructure scalable, modulaire et maintenable.

---

## 🧱 Architecture

L’infrastructure est divisée en 3 parties principales :

### 1. **Terraform - Provisionnement AWS**
- Création d’un **VPC personnalisé**
- 3 sous-réseaux :
  - `192.168.1.0/24` : Public (bastion, load balancer, Jenkins)
  - `192.168.10.0/24` : Privé App (3 serveurs Docker web)
  - `192.168.20.0/24` : Privé DB (MariaDB)
- Ressources AWS :
  - 🧩 1 Bastion (192.168.1.10)
  - 🌐 1 Load Balancer HAProxy (192.168.1.20)
  - 🔧 1 Jenkins (192.168.1.30)
  - 🖥️ 3 serveurs web Docker (192.168.10.11–13)
  - 🗄️ 1 serveur MariaDB (192.168.20.14)

### 2. **Ansible - Configuration automatisée**
- Installation et sécurisation de **MariaDB**
- Récupération automatique du `init.sql` depuis GitHub et création de la base `greenshop`
- Déploiement des conteneurs web :
  - Récupération de l'image Docker (Apache + PHP + Greenshop)
  - Lancement sur chaque serveur web, exposé sur le port 80
- Configuration de **HAProxy** :
  - Load balancing sur les 3 serveurs web en round-robin

### 3. **Jenkins - Intégration et Déploiement Continu**
- Déclencheur sur modification du dépôt **Greenshop Web**
- Build d’une nouvelle image Docker
- Push automatique sur **Docker Hub**
- Mise à jour automatique sur les 3 serveurs :
  - Suppression de l’ancien conteneur
  - Récupération et exécution de la nouvelle image

---

## 🛠 Technologies utilisées

| Outil      | Usage principal                          |
|------------|-------------------------------------------|
| Terraform  | Création des ressources AWS               |
| Ansible    | Provisionnement & configuration système   |
| Docker     | Conteneurisation des applications         |
| Jenkins    | CI/CD : automatisation des déploiements   |
| HAProxy    | Load balancing HTTP sur les serveurs web  |
| MariaDB    | Base de données relationnelle             |

---

## 🚀 Déploiement

1. **Configurer les credentials AWS** :
   Attention à bien modifié l'adresse IP public dans cidr_blocks pour accepter la votre.
   
   ```bash
   export AWS_ACCESS_KEY_ID=...
   export AWS_SECRET_ACCESS_KEY=...
   
3. **Terraform - Création de l’infra** :

   ```bash
   cd greenshop-terraform
   terraform init
   terraform apply
   
4. **Ansible - Configuration automatique** :

   ```bash
   cd greenshop-ansible
   ansible-playbook setup.yml -i inventory.ini

5. **Jenkins** :

    Accéder à Jenkins via l’IP publique du serveur Jenkins sur le port 8080

    Configurer un pipeline de type freestyle ou pipeline as code

    Webhook GitHub pour déclencher automatiquement les builds

📎 Notes complémentaires

    L’application PHP utilisée est un site de vente fictif : Greenshop

    Le init.sql est automatiquement récupéré depuis GitHub

    L’architecture permet un déploiement rapide en cas de mise à jour via Jenkins

👨‍🎓 Projet pédagogique

Ce projet a été réalisé dans un cadre étudiant dans le but de :

    Mettre en pratique l’IaC avec AWS

    Concevoir une infrastructure modulaire et automatisée

    Implémenter un pipeline CI/CD opérationnel

    Possibilité de basculer la base de données vers un conteneur Docker si besoin

📧 Auteur

Berzylyss
GitHub: https://github.com/Berzylyss

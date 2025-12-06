# Système Multijoueur - Contagion Creatures

## 🎮 Vue d'ensemble

Le système multijoueur a été complètement refait pour être simple et fonctionnel.

## 📋 Fonctionnalités

### Menu Principal
- Bouton **MULTIJOUEUR** depuis le menu principal
- Redirection vers `MultiplayerMenu.tscn`

### Menu Multijoueur (`MultiplayerMenu.tscn`)
- **Champ Pseudo** : Entrez votre nom de joueur
- **Bouton CRÉER UN SERVEUR** : Devient l'hôte
- **Bouton REJOINDRE UN SERVEUR** : Ouvre le formulaire de connexion
  - Champ **Adresse IP** : IP du serveur à rejoindre
  - Bouton **REJOINDRE** : Se connecte au serveur
  - Bouton **RETOUR** : Retour au menu principal

### Lobby (`Lobby.tscn`)
- **Liste des joueurs** : Affiche tous les joueurs connectés
  - Statut [PRÊT] ou pas prêt
  - Indication (Vous) pour le joueur local
  - Indication (Hôte) pour celui qui a créé le serveur
- **IP du serveur** : Affichée pour que les autres joueurs puissent rejoindre
- **Bouton PRÊT** : Toggle votre statut de prêt
- **Bouton DÉMARRER LA PARTIE** (visible uniquement pour l'hôte)
  - Actif uniquement quand tous les joueurs sont prêts
  - Lance la partie multijoueur
- **Bouton QUITTER** : Retour au menu multijoueur

### Map Multijoueur (`multiplayer_map.tscn`)
- Tous les joueurs apparaissent sur la map
- Système de synchronisation via `NetworkManager`
- Positions aléatoires au spawn

## 🔧 Architecture Technique

### NetworkManager (Autoload)
Singleton qui gère toute la logique réseau :
- `create_server()` : Crée un serveur
- `join_server(address)` : Rejoint un serveur
- `disconnect_from_game()` : Déconnexion propre
- `register_player()` : Enregistre un joueur
- `set_player_ready()` : Change le statut ready
- `start_game()` : Lance la partie (RPC)
- `get_local_ip()` : Récupère l'IP locale

### Signaux
- `player_connected(peer_id, player_info)`
- `player_disconnected(peer_id)`
- `server_disconnected()`

### Configuration
- **Port** : 9999
- **Max joueurs** : 8
- **Protocol** : ENet

## 🚀 Utilisation

### Pour héberger une partie :
1. Menu Principal → MULTIJOUEUR
2. Entrer votre pseudo
3. Cliquer sur CRÉER UN SERVEUR
4. Partager l'IP affichée aux autres joueurs
5. Attendre que les joueurs se connectent
6. Attendre que tout le monde soit prêt
7. Cliquer sur DÉMARRER LA PARTIE

### Pour rejoindre une partie :
1. Menu Principal → MULTIJOUEUR
2. Entrer votre pseudo
3. Cliquer sur REJOINDRE UN SERVEUR
4. Entrer l'IP du serveur
5. Cliquer sur REJOINDRE
6. Cliquer sur PRÊT quand vous êtes prêt
7. Attendre que l'hôte démarre

## ⚠️ Changements importants

### Supprimé :
- ❌ Système de login/register avec API
- ❌ `Global.user` et `Global.user_enemy`
- ❌ `SaveSystem.load_user()` et `SaveSystem.save_user()`
- ❌ Ancien système de matchmaking
- ❌ Écran profil avec connexion
- ❌ Liste de serveurs complexe

### Ajouté :
- ✅ `NetworkManager` autoload
- ✅ Lobby avec système de ready
- ✅ Menu multijoueur simplifié
- ✅ Gestion propre des connexions/déconnexions

## 🐛 Notes de débogage

- Le port 9999 doit être ouvert sur le pare-feu
- L'IP locale est détectée automatiquement (192.168.x.x ou 10.x.x.x)
- Les joueurs doivent être sur le même réseau local ou utiliser le port forwarding
- Tous les messages de debug sont dans la console avec `print()`

## 📁 Fichiers principaux

```
Scripts/
  └── NetworkManager.gd (Autoload)
Scenes/
  ├── MultiplayerMenu.tscn + .gd
  ├── Lobby.tscn + .gd
  └── Maps/
      └── multiplayer_map.gd
```

## 🎯 Prochaines étapes possibles

- [ ] Ajouter un système de chat
- [ ] Synchroniser les créatures de chaque joueur
- [ ] Ajouter des combats PvP
- [ ] Implémenter le commerce entre joueurs
- [ ] Ajouter des salons privés avec codes

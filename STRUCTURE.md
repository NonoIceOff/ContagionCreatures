# Structure du Projet ContagionCreatures

Ce document décrit l'organisation des fichiers du projet après réorganisation.

## 📁 Dossiers Principaux

### `/Scripts`
Tous les scripts GDScript du jeu, organisés par catégorie :

- **`/Scripts/UI/`** - Scripts d'interface utilisateur
  - Boutons (AppearenceButton, ControlsButton, SettingsButton)
  - Paramètres (settings, videosettings, controls_settings)
  - Langues (Languages, languages_settings)
  - Apparence (appearence)
  - Crédits (Credit_of_the_game)

- **`/Scripts/Managers/`** - Scripts de gestion globale
  - Animal_follow.gd
  - bdd.gd (base de données)
  - Quitter.gd

- **`/Scripts/Combat/`** - Scripts de combat
  - leave_fight.gd

- **`/Scripts/Maps/`** - Scripts des cartes
  - main_map.gd
  - map2.gd
  - map_3.gd
  - multiplayer_map.gd

- **`/Scripts/Minimap_FullMap/`** - Minimap et carte complète
  - Minimap.gd
  - minimap_2.gd

- **`/Scripts/Donjons/`** - Scripts des donjons

- **`/Scripts/Boutons/`** - Scripts de boutons spécifiques

- **`/Scripts/SkillTree/`** - Arbre de compétences

- **`/Scripts/`** (racine) - Scripts généraux
  - NetworkManager.gd (Autoload)
  - PlayerMultiplayer.gd
  - Player_1_Settings.gd
  - Global.gd
  - SaveSystem.gd
  - dialogue.gd
  - multiplayer.gd
  - etc.

### `/Scenes`
Toutes les scènes (.tscn) du jeu, organisées par type :

- **`/Scenes/Menus/`** - Menus du jeu
  - main_menu.tscn
  - menu.tscn
  - saves_menu.tscn
  - profil.tscn
  - MultiplayerMenu.tscn
  - Lobby.tscn

- **`/Scenes/Maps/`** - Cartes du jeu
  - main_map.tscn
  - map2.tscn
  - map3.tscn
  - map_4.tscn
  - multiplayer_map.tscn

- **`/Scenes/Combat/`** - Scènes de combat
  - scène_combat.tscn
  - scène_combat_multi.tscn
  - boss_fight.tscn
  - Precombat.tscn

- **`/Scenes/Dungeons/`** - Donjons
  - dungeon1.tscn
  - dungeon_enigme.tscn
  - dungeon_inversed.tscn
  - loytan_enigme_1.tscn
  - loytan_enigme_2.tscn

- **`/Scenes/UI/`** - Interface utilisateur
  - game_ui.tscn
  - ui.tscn
  - settings.tscn
  - controls.tscn
  - controls_settings.tscn
  - languages.tscn
  - videosettings.tscn
  - PauseMenu.tscn

- **`/Scenes/SkillTree/`** - Arbre de compétences

- **`/Scenes/Stats/`** - Statistiques

- **`/Scenes/Placables/`** - Objets plaçables

- **`/Scenes/`** (racine) - Scènes diverses
  - Player_1.tscn
  - Player_Multiplayer.tscn
  - animal.tscn
  - PNJ.tscn
  - dialogue.tscn
  - etc.

### `/Textures`
Toutes les images et sprites du jeu :
- Background_main_menu.png
- Background_main_menu2.png
- logo.png
- cc.png
- intérieur1.png
- Sous-dossiers pour sprites spécifiques

### `/Resources`
Fichiers de ressources Godot (.tres) :
- main_map.tres
- main_map_2.tres
- DropCrate.tres
- pin_shader.tres
- default_bus_layout.tres

### `/Localization`
Fichiers de traduction :
- translations.csv (source)
- translations.*.translation (langues compilées)
  - de (Allemand)
  - en (Anglais)
  - es (Espagnol)
  - fr (Français)
  - it (Italien)
  - jp (Japonais)

### `/Constantes`
Fichiers JSON de configuration :
- creatures.json
- Sous-dossier Quests/

### `/Inventory`
Système d'inventaire :
- Scripts et shaders
- Scènes d'interface
- Sous-dossier Items/

### `/Maze`
Système de génération de labyrinthes

### `/Sounds`
Fichiers audio et musiques

### `/Font`
Polices de caractères

### `/TileSet`
TileSets pour les cartes

### `/Thème`
Thèmes d'interface

### `/addons`
Extensions Godot :
- AsepriteWizard
- LPCAnimatedSprite

## 📋 Fichiers Racine

- `project.godot` - Configuration du projet Godot
- `README.md` - Documentation principale
- `MULTIPLAYER.md` - Documentation du système multijoueur
- `LICENSE` - Licence du projet
- `icon.svg` - Icône de l'application
- `scene_Choose_ATT.tscn` - Scène de choix d'attaque
- `controls_settings.tscn` - Paramètres de contrôles

## 🎯 Autoloads Configurés

Les scripts suivants sont chargés automatiquement au démarrage :
- `Global.gd`
- `SaveSystem.gd`
- `NetworkManager.gd`
- Autres selon configuration dans project.godot

## 📝 Notes

- Tous les fichiers temporaires (.tmp) ont été nettoyés
- Les doublons ont été supprimés
- Les scripts sont maintenant séparés des scènes pour une meilleure organisation
- Les fichiers sont regroupés par fonctionnalité pour faciliter la maintenance

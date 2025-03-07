# Scripts/Combat/SpellManager.gd
extends Node
class_name SpellManager

# Références aux boutons et aux sons (à initialiser depuis le script principal)
var spell_buttons = {}   # { "Spell_1": Button, "Spell_2": Button, ... }
var spell_sounds = {}    # { "Spell_1": AudioStreamPlayer2D, ... }

# Configure un bouton en fonction des données du sort
func configure_spell_button(button_name: String, spell_data: Dictionary) -> void:
    var button = get_node(button_name)
    if button:
        button.text = spell_data.name + " : " + str(spell_data.value)
        var attack_type = spell_data.element
        var attack_colors = {
            "fire": Color(1, 0, 0),
            "physical": Color(0.72, 0.53, 0.04),
            "ice": Color(0, 0.5, 1),
            "magic": Color(0.7, 0.3, 1)
        }
        if attack_colors.has(attack_type):
            button.modulate = attack_colors[attack_type]
        # Affichage de la difficulté et du mode (sur des labels enfants)
        var difficulty_label = button.get_node("difficulty" + button_name.substr(-1))
        if difficulty_label:
            difficulty_label.text = str(spell_data.difficulty)
        var type_label = button.get_node("type" + button_name.substr(-1))
        if type_label:
            type_label.text = str(spell_data.mode)
    else:
        print("Erreur : Le bouton", button_name, "n'existe pas.")

# Connecte le bouton à une fonction de debug et à l'exécution du sort
func connect_spell_button_with_debug(button_name: String, spells: Array, index: int):
    if spells.size() > index:
        var button = get_node(button_name)
        if button:
            var spell_data = spells[index]
            button.connect("pressed", Callable(get_parent(), "_debug_spell_info").bind(spell_data))
            button.connect("pressed", Callable(get_parent(), "_on_spell_button_pressed").bind(spell_data))
        else:
            print("Erreur : Le bouton", button_name, "n'existe pas.")
    else:
        print("Erreur : Index de sort invalide pour", button_name)

# Méthode pour exécuter le sort lors de l'appui sur un bouton (appelé par CombatManager via _input)
func _execute_spell_action(button_name: String, index: int) -> void:
    var spells = get_parent().creatures_spells  # Supposons que le script principal stocke ces données
    if spells.size() > index:
        var spell_data = spells[index]
        # Afficher les infos de debug
        get_parent()._debug_spell_info(spell_data)
        # Jouer le son associé
        match button_name:
            "Spell_1":
                spell_sounds["Spell_1"].play()
            "Spell_2":
                spell_sounds["Spell_2"].play()
            "Spell_3":
                spell_sounds["Spell_3"].play()
            "Spell_4":
                spell_sounds["Spell_4"].play()
        # Lancer l'action de sort (via CombatManager)
        get_parent()._on_spell_button_pressed(spell_data)
    else:
        print("Erreur : Index de sort invalide pour", button_name)

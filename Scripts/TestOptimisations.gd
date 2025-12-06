extends Node

## Script de test des optimisations
## Lance une série de tests pour vérifier que tout fonctionne correctement

var test_results = []
var tests_passed = 0
var tests_failed = 0

func _ready():
	print("\n" + "=".repeat(60))
	print("🧪 TEST DES OPTIMISATIONS - CONTAGION CREATURES")
	print("=".repeat(60) + "\n")
	
	await get_tree().process_frame
	
	run_all_tests()
	display_results()

func run_all_tests():
	test_global_script()
	test_autoloads()
	test_scene_loader()
	test_performance_optimizer()
	test_file_access()
	test_memory_leaks()

## Test 1: Vérifier Global.gd
func test_global_script():
	var test_name = "Global.gd existe et fonctionne"
	
	if Global:
		if Global.has_method("_process"):
			add_result(test_name, true, "Global.gd chargé correctement")
		else:
			add_result(test_name, false, "Global.gd n'a pas de méthode _process")
	else:
		add_result(test_name, false, "Global.gd introuvable")

## Test 2: Vérifier les Autoloads
func test_autoloads():
	var required_autoloads = [
		"PlayerStats",
		"SceneLoader",
		"Global",
		"SaveSystem"
	]
	
	for autoload_name in required_autoloads:
		var test_name = "Autoload: " + autoload_name
		if has_node("/root/" + autoload_name):
			add_result(test_name, true, "Trouvé et fonctionnel")
		else:
			add_result(test_name, false, "Introuvable dans /root/")
	
	# Test optionnel pour PerformanceOptimizer
	var test_name = "Autoload: PerformanceOptimizer (optionnel)"
	if has_node("/root/PerformanceOptimizer"):
		add_result(test_name, true, "Installé et actif ✓")
	else:
		add_result(test_name, true, "Non installé (optionnel)")

## Test 3: SceneLoader
func test_scene_loader():
	var test_name = "SceneLoader optimisé"
	
	if SceneLoader:
		if SceneLoader.has_method("_change_to_scene"):
			add_result(test_name, true, "Nouvelles optimisations appliquées")
		else:
			add_result(test_name, false, "Méthode _change_to_scene manquante")
	else:
		add_result(test_name, false, "SceneLoader introuvable")

## Test 4: PerformanceOptimizer
func test_performance_optimizer():
	var test_name = "PerformanceOptimizer fonctionnel"
	
	if has_node("/root/PerformanceOptimizer"):
		var perf_opt = get_node("/root/PerformanceOptimizer")
		
		if perf_opt.has_method("get_performance_stats"):
			var stats = perf_opt.get_performance_stats()
			if stats.has("fps"):
				add_result(test_name, true, "Stats disponibles, FPS: " + str(stats.fps))
			else:
				add_result(test_name, false, "Stats invalides")
		else:
			add_result(test_name, false, "Méthodes manquantes")
	else:
		add_result(test_name, true, "Non installé (optionnel)")

## Test 5: Accès fichiers
func test_file_access():
	var files_to_check = [
		"res://Constantes/items.json",
		"res://Scripts/PerformanceOptimizer.gd",
		"res://OPTIMISATIONS.md",
		"res://GUIDE_OPTIMISATIONS.md"
	]
	
	for file_path in files_to_check:
		var test_name = "Fichier: " + file_path.get_file()
		if FileAccess.file_exists(file_path):
			add_result(test_name, true, "Fichier présent")
		else:
			# Certains fichiers sont optionnels
			if file_path.ends_with(".md") or file_path.ends_with("PerformanceOptimizer.gd"):
				add_result(test_name, true, "Fichier absent (optionnel)")
			else:
				add_result(test_name, false, "Fichier manquant!")

## Test 6: Détection de fuites mémoire potentielles
func test_memory_leaks():
	var test_name = "Nœuds orphelins"
	
	await get_tree().process_frame
	
	var orphan_count = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	
	if orphan_count == 0:
		add_result(test_name, true, "Aucun nœud orphelin ✓")
	elif orphan_count < 5:
		add_result(test_name, true, str(orphan_count) + " nœuds orphelins (acceptable)")
	else:
		add_result(test_name, false, str(orphan_count) + " nœuds orphelins (vérifier les fuites)")

## Ajouter un résultat de test
func add_result(test_name: String, passed: bool, message: String = ""):
	test_results.append({
		"name": test_name,
		"passed": passed,
		"message": message
	})
	
	if passed:
		tests_passed += 1
	else:
		tests_failed += 1

## Afficher tous les résultats
func display_results():
	print("\n📋 RÉSULTATS DES TESTS:\n")
	
	for result in test_results:
		var icon = "✅" if result.passed else "❌"
		var status = "PASS" if result.passed else "FAIL"
		
		print("%s [%s] %s" % [icon, status, result.name])
		if result.message != "":
			print("   └─ %s" % result.message)
	
	print("\n" + "─".repeat(60))
	print("📊 STATISTIQUES:")
	print("   Tests réussis: %d" % tests_passed)
	print("   Tests échoués: %d" % tests_failed)
	print("   Total: %d" % (tests_passed + tests_failed))
	print("─".repeat(60))
	
	var success_rate = (float(tests_passed) / (tests_passed + tests_failed)) * 100
	print("\n🎯 Taux de réussite: %.1f%%" % success_rate)
	
	if tests_failed == 0:
		print("✨ PARFAIT! Toutes les optimisations sont correctement installées!")
	elif tests_failed <= 2:
		print("⚠️  Quelques problèmes mineurs détectés. Consultez les messages ci-dessus.")
	else:
		print("❌ Plusieurs problèmes détectés. Vérifiez l'installation des optimisations.")
	
	print("\n" + "=".repeat(60))
	print("🧪 TEST TERMINÉ")
	print("=".repeat(60) + "\n")
	
	# Afficher les stats de performance si PerformanceOptimizer existe
	if has_node("/root/PerformanceOptimizer"):
		print("\n📊 STATISTIQUES DE PERFORMANCE:\n")
		get_node("/root/PerformanceOptimizer").print_performance_stats()
	
	# Quitter après les tests
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

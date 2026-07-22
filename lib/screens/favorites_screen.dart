import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/pokemon_card.dart';
import 'home_screen.dart' show allPokemons;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> _favoriteIds = {};
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = (_prefs.getStringList('favoritos') ?? []).toSet();
    });
  }

  Future<void> _toggleFavorite(String id, String displayName) async {
    setState(() => _favoriteIds.remove(id));
    await _prefs.setStringList('favoritos', _favoriteIds.toList());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$displayName quitado de favoritos'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritos =
        allPokemons.where((p) => _favoriteIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favoritos.isEmpty
          ? const Center(child: Text('Todavía no tienes favoritos :('))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final pokemon = favoritos[index];
                return GestureDetector(
                  onTap: () =>
                      context.push('/pokemon/${pokemon.id}', extra: pokemon),
                  child: PokemonCard(
                    pokemon: pokemon,
                    esFavorito: true,
                    onFavoritoTap: () =>
                        _toggleFavorite(pokemon.id, pokemon.displayName),
                  ),
                );
              },
            ),
    );
  }
}

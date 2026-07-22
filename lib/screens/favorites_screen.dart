import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final PokemonService _service = PokemonService();

  Set<String> _favoriteIds = {};
  List<Pokemon> _favoritos = [];
  late final SharedPreferences _prefs;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _prefs = await SharedPreferences.getInstance();
    final ids = (_prefs.getStringList('favoritos') ?? []).toSet();

    try {
      final favoritos = await Future.wait(
        ids.map((id) => _service.fetchPokemonByIdOrName(id)),
      );
      if (!mounted) return;
      setState(() {
        _favoriteIds = ids;
        _favoritos = favoritos;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar tus favoritos. Revisa tu conexión.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleFavorite(String id, String displayName) async {
    setState(() {
      _favoriteIds.remove(id);
      _favoritos.removeWhere((p) => p.id == id);
    });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadFavorites,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_favoritos.isEmpty) {
      return const Center(child: Text('Todavía no tienes favoritos :('));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoritos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final pokemon = _favoritos[index];
        return GestureDetector(
          onTap: () => context.push('/pokemon/${pokemon.id}', extra: pokemon),
          child: PokemonCard(
            pokemon: pokemon,
            esFavorito: true,
            onFavoritoTap: () =>
                _toggleFavorite(pokemon.id, pokemon.displayName),
          ),
        );
      },
    );
  }
}

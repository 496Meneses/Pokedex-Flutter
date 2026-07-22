import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

const String _todosLosTipos = 'Todos';
const int _pageLimit = 20;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _service = PokemonService();
  final ScrollController _scrollController = ScrollController();

  final List<Pokemon> _pokemons = [];
  Set<String> _favoriteIds = {};
  late final SharedPreferences _prefs;

  String _searchQuery = '';
  String _selectedType = _todosLosTipos;

  int _offset = 0;
  bool _hasMore = true;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchNextPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _favoriteIds = (_prefs.getStringList('favoritos') ?? []).toSet();
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasMore) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    setState(() {
      if (_pokemons.isEmpty) {
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
      _error = null;
    });

    try {
      final nuevos = await _service.fetchPokemons(
        limit: _pageLimit,
        offset: _offset,
      );
      if (!mounted) return;
      setState(() {
        _pokemons.addAll(nuevos);
        _offset += _pageLimit;
        _hasMore = nuevos.length == _pageLimit;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar los Pokémon. Revisa tu conexión.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(Pokemon pokemon) async {
    final estabaEnFavoritos = _favoriteIds.contains(pokemon.id);
    setState(() {
      if (estabaEnFavoritos) {
        _favoriteIds.remove(pokemon.id);
      } else {
        _favoriteIds.add(pokemon.id);
      }
    });
    await _prefs.setStringList('favoritos', _favoriteIds.toList());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(estabaEnFavoritos
            ? '${pokemon.displayName} quitado de favoritos'
            : '${pokemon.displayName} añadido a favoritos'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableTypes = <String>{
      _todosLosTipos,
      ..._pokemons.expand((p) => p.types),
    }.toList();

    final filtered = _pokemons.where((pokemon) {
      final matchesName = pokemon.displayName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == _todosLosTipos ||
          pokemon.types.contains(_selectedType);
      return matchesName && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Busca un Pokémon...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: _selectedType,
                items: availableTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(_capitalize(type)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(filtered)),
        ],
      ),
    );
  }

  Widget _buildBody(List<Pokemon> filtered) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _pokemons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchNextPage,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return const Center(child: Text('Ningún Pokémon coincide'));
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final pokemon = filtered[index];
                return GestureDetector(
                  onTap: () =>
                      context.push('/pokemon/${pokemon.id}', extra: pokemon),
                  child: PokemonCard(
                    pokemon: pokemon,
                    esFavorito: _favoriteIds.contains(pokemon.id),
                    onFavoritoTap: () => _toggleFavorite(pokemon),
                  ),
                );
              },
              childCount: filtered.length,
            ),
          ),
        ),
        if (_isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

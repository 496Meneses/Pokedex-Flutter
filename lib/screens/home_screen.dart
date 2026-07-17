import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

final List<Pokemon> allPokemons = [
  Pokemon(id: '1', name: 'bulbasaur', displayName: 'Bulbasaur', types: const ['grass', 'poison'], hp: 45, attack: 49, defense: 49),
  Pokemon(id: '4', name: 'charmander', displayName: 'Charmander', types: const ['fire'], hp: 39, attack: 52, defense: 43),
  Pokemon(id: '7', name: 'squirtle', displayName: 'Squirtle', types: const ['water'], hp: 44, attack: 48, defense: 65),
  Pokemon(id: '25', name: 'pikachu', displayName: 'Pikachu', types: const ['electric'], hp: 35, attack: 55, defense: 40),
  Pokemon(id: '39', name: 'jigglypuff', displayName: 'Jigglypuff', types: const ['normal', 'fairy'], hp: 115, attack: 45, defense: 20),
  Pokemon(id: '74', name: 'geodude', displayName: 'Geodude', types: const ['rock', 'ground'], hp: 40, attack: 80, defense: 100),
  Pokemon(id: '92', name: 'gastly', displayName: 'Gastly', types: const ['ghost', 'poison'], hp: 30, attack: 35, defense: 30),
  Pokemon(id: '66', name: 'machop', displayName: 'Machop', types: const ['fighting'], hp: 70, attack: 80, defense: 50),
];

const String _todosLosTipos = 'Todos';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedType = _todosLosTipos;

  @override
  Widget build(BuildContext context) {
    final availableTypes = <String>{
      _todosLosTipos,
      ...allPokemons.expand((p) => p.types),
    }.toList();

    final filtered = allPokemons.where((pokemon) {
      final matchesName =
          pokemon.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType =
          _selectedType == _todosLosTipos || pokemon.types.contains(_selectedType);
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
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Ningún Pokémon coincide'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final pokemon = filtered[index];
                      return GestureDetector(
                        onTap: () => context
                            .push('/pokemon/${pokemon.id}', extra: pokemon),
                        child: PokemonCard(pokemon: pokemon),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

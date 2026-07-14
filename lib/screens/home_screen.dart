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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allPokemons.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final pokemon = allPokemons[index];
          return GestureDetector(
            onTap: () => context.push('/pokemon/${pokemon.id}', extra: pokemon),
            child: PokemonCard(pokemon: pokemon),
          );
        },
      ),
    );
  }
}

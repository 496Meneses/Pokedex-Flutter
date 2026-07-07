import 'package:flutter/material.dart';

import 'models/pokemon.dart';
import 'widgets/pokemon_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const List<Pokemon> pokemones = [
    Pokemon(id: '1', name: 'bulbasaur', displayName: 'Bulbasaur', types: ['grass', 'poison']),
    Pokemon(id: '4', name: 'charmander', displayName: 'Charmander', types: ['fire']),
    Pokemon(id: '7', name: 'squirtle', displayName: 'Squirtle', types: ['water']),
    Pokemon(id: '25', name: 'pikachu', displayName: 'Pikachu', types: ['electric']),
    Pokemon(id: '39', name: 'jigglypuff', displayName: 'Jigglypuff', types: ['normal', 'fairy']),
    Pokemon(id: '74', name: 'geodude', displayName: 'Geodude', types: ['rock', 'ground']),
    Pokemon(id: '92', name: 'gastly', displayName: 'Gastly', types: ['ghost', 'poison']),
    Pokemon(id: '66', name: 'machop', displayName: 'Machop', types: ['fighting']),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PokeDex')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pokemones.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => PokemonCard(pokemon: pokemones[index]),
        ),
      ),
    );
  }
}

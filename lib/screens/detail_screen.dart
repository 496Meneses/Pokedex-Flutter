import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../widgets/type_chip.dart';
import 'home_screen.dart' show allPokemons;

class DetailScreen extends StatelessWidget {
  final String id;
  final Pokemon? pokemon;

  const DetailScreen({super.key, required this.id, this.pokemon});

  @override
  Widget build(BuildContext context) {
    final resolved =
        pokemon ?? allPokemons.firstWhere((p) => p.id == id);

    return Scaffold(
      appBar: AppBar(title: Text(resolved.displayName)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.network(
              resolved.imageUrl,
              height: 200,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 200),
            ),
            const SizedBox(height: 16),
            Text(
              resolved.displayName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              alignment: WrapAlignment.center,
              children:
                  resolved.types.map((type) => TypeChip(type: type)).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(label: 'HP', value: resolved.hp),
                _Stat(label: 'ATK', value: resolved.attack),
                _Stat(label: 'DEF', value: resolved.defense),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/pokemon.dart';

const Map<String, Color> _typeColors = {
  'grass': Color(0xFF78C850),
  'poison': Color(0xFFA040A0),
  'fire': Color(0xFFF08030),
  'water': Color(0xFF6890F0),
  'electric': Color(0xFFF8D030),
  'normal': Color(0xFFA8A878),
  'fairy': Color(0xFFEE99AC),
  'rock': Color(0xFFB8A038),
  'ground': Color(0xFFE0C068),
  'ghost': Color(0xFF705898),
  'fighting': Color(0xFFC03028),
};

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              pokemon.imageUrl,
              height: 96,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 96),
            ),
            const SizedBox(height: 12),
            Text(
              pokemon.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: pokemon.types.map((type) {
                return Chip(
                  label: Text(
                    _capitalize(type),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: _typeColors[type] ?? Colors.grey,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

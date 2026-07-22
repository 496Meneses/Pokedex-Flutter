import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import 'type_chip.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool esFavorito;
  final VoidCallback onFavoritoTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.esFavorito,
    required this.onFavoritoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  pokemon.imageUrl,
                  height: 96,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 96),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: IconButton(
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: esFavorito ? Colors.red : null,
                    ),
                    onPressed: onFavoritoTap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pokemon.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: pokemon.types
                  .map((type) => TypeChip(type: type))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

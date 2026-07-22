import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

const int _maxBaseStat = 255;

class DetailScreen extends StatefulWidget {
  final String id;
  final Pokemon? pokemon;

  const DetailScreen({super.key, required this.id, this.pokemon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PokemonService _service = PokemonService();
  late final Future<Pokemon> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.pokemon != null
        ? Future.value(widget.pokemon)
        : _service.fetchPokemonByIdOrName(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pokemon>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cargando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pokémon')),
            body: const Center(
              child: Text('No se pudo cargar este Pokémon.'),
            ),
          );
        }

        final resolved = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(resolved.displayName)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    resolved.imageUrl,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 200),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    resolved.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: resolved.types
                        .map((type) => Chip(label: Text(type)))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                _StatBar(label: 'hp', value: resolved.hp),
                _StatBar(label: 'attack', value: resolved.attack),
                _StatBar(label: 'defense', value: resolved.defense),
                _StatBar(
                    label: 'special-attack', value: resolved.specialAttack),
                _StatBar(
                    label: 'special-defense', value: resolved.specialDefense),
                _StatBar(label: 'speed', value: resolved.speed),
                const SizedBox(height: 24),
                Text(
                  'Habilidades',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final ability in resolved.abilities)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $ability'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;

  const _StatBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (value / _maxBaseStat).clamp(0, 1).toDouble(),
                minHeight: 8,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                color: colorScheme.primary,
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

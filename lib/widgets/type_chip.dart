import 'package:flutter/material.dart';

const Map<String, Color> typeColors = {
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

class TypeChip extends StatelessWidget {
  final String type;

  const TypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        _capitalize(type),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.white),
      ),
      backgroundColor: typeColors[type] ?? Colors.grey,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

class Pokemon {
  final String id;
  final String name;
  final String displayName;
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.displayName,
    required this.types,
  });

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

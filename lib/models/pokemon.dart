class Pokemon {
  final String id;
  final String name;
  final String displayName;
  final List<String> types;
  final int hp;
  final int attack;
  final int defense;

  const Pokemon({
    required this.id,
    required this.name,
    required this.displayName,
    required this.types,
    required this.hp,
    required this.attack,
    required this.defense,
  });

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class Pokemon {
  final String id;
  final String name;
  final String displayName;
  final List<String> types;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final List<String> abilities;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.displayName,
    required this.types,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.abilities,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final name = json['name'] as String;

    final types = (json['types'] as List)
        .map((entry) => entry['type']['name'] as String)
        .toList();

    final baseStats = <String, int>{
      for (final entry in json['stats'] as List)
        entry['stat']['name'] as String: entry['base_stat'] as int,
    };

    final abilities = (json['abilities'] as List)
        .map((entry) => entry['ability']['name'] as String)
        .toList();

    final sprites = json['sprites'] as Map<String, dynamic>?;
    final officialArtwork =
        (sprites?['other'] as Map<String, dynamic>?)?['official-artwork']
            as Map<String, dynamic>?;
    final imageUrl = officialArtwork?['front_default'] as String? ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: name,
      displayName: _capitalize(name),
      types: types,
      hp: baseStats['hp'] ?? 0,
      attack: baseStats['attack'] ?? 0,
      defense: baseStats['defense'] ?? 0,
      specialAttack: baseStats['special-attack'] ?? 0,
      specialDefense: baseStats['special-defense'] ?? 0,
      speed: baseStats['speed'] ?? 0,
      abilities: abilities,
      imageUrl: imageUrl,
    );
  }

  static String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
}

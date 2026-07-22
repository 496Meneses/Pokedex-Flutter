import 'package:dio/dio.dart';

import '../models/pokemon.dart';

class PokemonService {
  PokemonService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));

  final Dio _dio;

  /// Trae una página de Pokémon (nombre + detalle) ordenados por id.
  Future<List<Pokemon>> fetchPokemons({
    required int limit,
    required int offset,
  }) async {
    final listResponse = await _dio.get<Map<String, dynamic>>(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final results = (listResponse.data!['results'] as List)
        .cast<Map<String, dynamic>>();

    return Future.wait(
      results.map((result) => fetchPokemonByIdOrName(result['name'] as String)),
    );
  }

  Future<Pokemon> fetchPokemonByIdOrName(String idOrName) async {
    final response =
        await _dio.get<Map<String, dynamic>>('/pokemon/$idOrName');
    return Pokemon.fromJson(response.data!);
  }
}

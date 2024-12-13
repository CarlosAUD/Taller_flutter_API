import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Buscador',
      theme: ThemeData.dark(), // Activar el modo oscuro
      home: PokemonSearchPage(),
    );
  }
}

class PokemonSearchPage extends StatefulWidget {
  @override
  _PokemonSearchPageState createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  final TextEditingController _controller = TextEditingController();
  var _pokemonData;

  Future<void> _fetchPokemonData(String pokemonName) async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));

    if (response.statusCode == 200) {
      setState(() {
        _pokemonData = json.decode(response.body);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Pokémon no encontrado'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador de Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del Pokémon',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _fetchPokemonData(_controller.text.toLowerCase());
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _pokemonData == null
                ? Container()
                : Expanded(
                    child: ListView(
                      children: [
                        Image.network(_pokemonData['sprites']['front_default']),
                        Text(
                          'Nombre: ${_pokemonData['name']}',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Habilidades:',
                          style: TextStyle(fontSize: 18),
                        ),
                        for (var ability in _pokemonData['abilities'])
                          Text(ability['ability']['name']),
                        SizedBox(height: 10),
                        Text(
                          'Estadísticas:',
                          style: TextStyle(fontSize: 18),
                        ),
                        for (var stat in _pokemonData['stats'])
                          Text('${stat['stat']['name']}: ${stat['base_stat']}'),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

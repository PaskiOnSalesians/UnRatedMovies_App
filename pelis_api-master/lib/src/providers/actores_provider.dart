import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

class ActoresProvider {
  String _apikey = '0f67911333630b6f4c3cb220891ec8b8';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _populares = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Cast.fromJsonList(decodedData['results']);

    return actores.actores;
  }

  Future<List<Actor>> getActorPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/person/popular', {'api_key': _apikey, 'language': _language, 'page': _popularesPage.toString()}); 
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getFoto() async{
    final url = Uri.https(_url, '3/person/popular', {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['profile_path']);

    return cast.actores;
  }

/*
  Future<List<Actor>> getKnownMovies(int personid) async {
    final url = Uri.https(_url, '3/person/$personid/movie_credits', {'api_key': _apikey, 'language': _language});  // pelicula
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }
*/

  Future<String> getBiography(int personid) async{
    final url = Uri.https(_url, '3/person/$personid', {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    //final cast = new Cast.fromJsonList(decodedData['biography']);

    //return cast.actores;
    return decodedData['biography'];
  }

  Future<List<Pelicula>> getMovie(int personid) async {
    final url = Uri.https(_url, '3/person/$personid/movie_credits', {'api_key': _apikey, 'language': _language});  // pelicula
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    //final cast = new Pelicula.fromJsonList(decodedData['cast']);

    return decodedData['cast'];
  }

  Future<List<Actor>> buscarActor(String query) async {
    final url = Uri.https(_url, '3/search/person', {'api_key': _apikey, 'language': _language, 'query': query});  // Pelicula
    
    return await _procesarRespuesta(url);
  }
}

import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
//import 'package:scooby_app/src/models/pelicula_model.dart';

import 'package:scooby_app/src/providers/actores_provider.dart';

class ActoresDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;
    //final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            //_posterTitulo(context, actor),
            _descripcion(actor),
            //_crearMovies(actor),
            //_knownForMovies(actor),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage("https://image.tmdb.org/t/p/w500" + actor.profilePath),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _descripcion(Actor actor) {
    final actoresProvider = new ActoresProvider();
    return FutureBuilder(
      future: actoresProvider.getBiography(actor.id),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  snapshot.data,
                  textAlign: TextAlign.justify,
                  ),
              ),
            ]
          );
        } else {
          return Text('No hay descripción disponible') /*Center(child: CircularProgressIndicator())*/;
        }
      },
    );
  }
  /*

  Widget _crearMovies(Actor actor) {
    final actorProvider = new ActoresProvider();

    return FutureBuilder(
      future: actorProvider.getKnownMovies(actor.id),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearPeliculasPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearPeliculasPageView(List<Actor> actor) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actor.length,
        itemBuilder: (context, i) => _knownForMovies(actor[i]),
      ),
    );
  }

  Widget _knownForMovies(Actor actor){
    final actorProvider = new ActoresProvider();

    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(actor.getFoto()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          'Test',
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }*/
}

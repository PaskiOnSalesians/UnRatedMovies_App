import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

import 'package:scooby_app/src/widgets/actor_horizontal.dart';

import 'package:scooby_app/src/providers/actores_provider.dart';
import 'package:scooby_app/src/providers/peliculas_provider.dart';

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
            _crearMovies(actor, context),
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
      // expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
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
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 30),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("https://image.tmdb.org/t/p/w500" + actor.profilePath),
                      radius: 75
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 0, bottom: 20),
                    child: Text(
                      actor.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearMovies(Actor actor, BuildContext context) {
    final actoresProvider = new ActoresProvider();

    return FutureBuilder(
      future: actoresProvider.getMovie(actor.id),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearPeliculasPageView(snapshot.data);
        } else {
          return Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _crearPeliculasPageView(List<Pelicula> pelicula) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: pelicula.length,
        itemBuilder: (context, i) => _peliTarjeta(pelicula[i]),
      ),
    );
  }

  Widget _peliTarjeta(Pelicula peliculas){
    //final peliculasProvider = new PeliculasProvider();

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(peliculas.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            peliculas.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }
}

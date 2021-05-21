import 'package:http/http.dart' as http;
import 'package:test2/models/movie.dart';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';


void main()=>runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false,));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController pageController = PageController(initialPage: 0);
  int pageChange = 0;
  String trendingRoute = 'data/trending_movie.json';
  String discoverRoute = 'data/discover_movie.json';
  //Favorite
  List<int> favorIDs = [];
  List<Movie> addFavors = [];

  //Get data movie in JSON local file
  Future<List<Movie>> getMovieData(String url) async {
    var movieJson = await rootBundle.loadString(url);
    var jsonData = json.decode(movieJson);
    var jsonResult = jsonData['results'];
    List<Movie> movies = [];

    for(var t in jsonResult) {
      Movie movie = Movie(t["id"], t["title"], t["vote_average"]);
      movies.add(movie);
    }
    return movies;
  }

  @override
  void initState() {
    super.initState();
    this.getMovieData(trendingRoute);
    this.getMovieData(discoverRoute);
  }

  // Fail to get API although the link is correct
  // So I temporary use file json instead
  // API trending: https://api.themoviedb.org/3/trending/movie/day?api_key=061e411e417766bfc7b370d08d2fbd49&language=english
  // API discover: https://api.themoviedb.org/3/discover/movie?api_key=061e411e417766bfc7b370d08d2fbd49&language=english
  /*
  final String apiKey = "061e411e417766bfc7b370d08d2fbd49";

  getTrendingData() async {
    final response =
    await http.get(Uri.https('api.themoviedb.org', '3/trending/movie/day?api_key=061e411e417766bfc7b370d08d2fbd49&language=english'));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData.toString());
      //   var jsonResult = jsonData['results'];
      List<TrendingMovie> trendingMovies = [];

      for(var t in jsonData) {
        TrendingMovie trendingMovie = TrendingMovie(t["title"], t["vote_average"]);
        trendingMovies.add(trendingMovie);
      }
      print(trendingMovies.length);
      return trendingMovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load API');
    }
  }
  */
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies'),
      
      actions: [
        IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          pageController.animateToPage(--pageChange, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
          if(pageChange < 2) pageChange = 0;
        }),
        IconButton(icon: Icon(Icons.arrow_forward), onPressed: (){
          pageController.animateToPage(++pageChange, duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
          if(pageChange > 2) pageChange = 2;
        }),
      ]
      ),

      body: PageView(
        pageSnapping: true,
        controller: pageController,
        onPageChanged: (index){
          setState(() {
              pageChange = index;
          });
         // print(pageChange);
        },
        children: [
          //-----Trending Movie-----
          Scaffold(
            appBar: AppBar(title: Text('Trending Movies'),),
              body: Container(
                child: Card(
                  child: FutureBuilder(
                    future: getMovieData(trendingRoute),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null) {
                        return Container(
                            child: Padding(
                               padding: const EdgeInsets.only(top: 16),
                              child: Text('Loading...'),
                      ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int i){
                              //Favorite
                              bool isSaved = favorIDs.contains(snapshot.data[i].id);
                              return ListTile(
                                title: Text(
                                  '${i+1}. ${snapshot.data[i].title}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),),
                                subtitle: Text(
                                  '       Rating: ${snapshot.data[i].voteAverage}',
                                  style: TextStyle(
                                      fontSize: 20,
                                  ),
                                ),
                                trailing: Icon(
                                  isSaved ? Icons.favorite : Icons.favorite_border,
                                  color: isSaved ? Colors.red : null,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (isSaved) {
                                      addFavors.removeWhere((movie) => movie.id == snapshot.data[i].id);
                                      favorIDs.remove(snapshot.data[i].id);
                                    } else {
                                      favorIDs.add(snapshot.data[i].id);
                                      addFavors.add(Movie(snapshot.data[i].id, snapshot.data[i].title, snapshot.data[i].voteAverage));
                                    }
                                  });
                                },
                              );
                        });
                      }
                    },
                  ),
                ),
              ),
          ),
          //-----\\Trending Movie-----

          //-----Discover Movie-----
          Scaffold(
            appBar: AppBar(title: Text('Discover Movies'),),
            body: Container(
              child: Card(
                child: FutureBuilder(
                  future: getMovieData(discoverRoute),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data == null) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Loading...'),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context,int i){
                            //Favorite
                            bool isSaved = favorIDs.contains(snapshot.data[i].id);
                            return ListTile(
                              title: Text(
                                '${i+1}. ${snapshot.data[i].title}',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                              subtitle: Text(
                                '       Rating: ${snapshot.data[i].voteAverage}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: Icon(
                                isSaved ? Icons.favorite : Icons.favorite_border,
                                color: isSaved ? Colors.red : null,
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSaved) {
                                    addFavors.removeWhere((movie) => movie.id == snapshot.data[i].id);
                                    favorIDs.remove(snapshot.data[i].id);
                                  } else {
                                    favorIDs.add(snapshot.data[i].id);
                                    addFavors.add(Movie(snapshot.data[i].id, snapshot.data[i].title, snapshot.data[i].voteAverage));
                                  }
                                });
                              },
                            );
                          });
                    }
                  },
                ),
              ),
            ),
          ),
          //-----\\Discover Movie-----

          //-----Favorite Movie-----
          Scaffold(
            appBar: AppBar(title: Text('Favorite Movies'),),
            body: ListView.builder(
                itemCount: addFavors.length,
                itemBuilder: (BuildContext context,int i){
                  return ListTile(
                    title: Text(
                      '${i+1}. ${addFavors[i].title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),),
                    subtitle: Text(
                      'Rating: ${addFavors[i].voteAverage}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                }),
          ),
          //-----\\Favorite Movie-----

        ],
      ),
    );
  }
}
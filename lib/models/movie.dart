class Movie {
  int id;
  String title;
  double voteAverage;

  Movie(this.id, this.title, this.voteAverage);

  Movie.fromJson(Map<String, dynamic> json, this.id, this.title, this.voteAverage) {
    id = json['id'];
    title = json['title'];
    voteAverage = json['vote_average'];
  }
}
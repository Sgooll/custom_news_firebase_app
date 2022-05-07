class Profile{
  String email;
  var favourites;

  Profile({
    required this.email,
    required this.favourites,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        email: json['email'],
        favourites: json['favourites'],
    );
  }
}
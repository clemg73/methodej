class User {
  final int? id;
  final String? name;
  final String? mdp;
  final bool? premium;

  User({this.id, this.name, this.mdp, this.premium});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], mdp: json['mdp']);
  }
  factory User.fromMap(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], mdp: json['mdp']);
  }
  Map<String, dynamic> toJson() => {"name": name, "mdp": mdp};
  Map<String, dynamic> toJsonForDoPremium() =>
      {"name": name, "mdp": mdp, "premium": premium};
}

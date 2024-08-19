class Sign {
  final String name;
  final String gif;
  final List<String> tags;

  Sign({required this.name, required this.gif, this.tags = const []});

  //Creates an object for the gestures data.

  factory Sign.fromMap(Map<String, dynamic> map) {
    return Sign(
      name: map['name'],
      gif: map['gif'],
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}

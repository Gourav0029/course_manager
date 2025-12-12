class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> m) => Category(id: m['id'].toString(), name: m['name'].toString());

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}

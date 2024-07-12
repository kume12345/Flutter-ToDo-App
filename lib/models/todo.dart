class Todo {
  int? id;
  int categoryId;
  int isDone;
  String description;

  Todo({
    this.id,
    required this.categoryId,
    required this.isDone,
    required this.description,
  });
  // Convert a Todo object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'isDone': isDone,
      'description': description,
    };
    return map;
  }

  // Extract a Todo object from a Map object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      categoryId: map['categoryId'],
      isDone: map['isDone'],
      description: map['description'],
    );
  }
}

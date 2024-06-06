import 'package:cloud_firestore/cloud_firestore.dart';

class todo {
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;

  todo(
      {required this.task,
      required this.createdOn,
      required this.isDone,
      required this.updatedOn});

  factory todo.fromJson(Map<String, Object?> Json) {
    return todo(
        task: Json['task']?.toString() ?? "",
        isDone: Json['isDone']! as bool,
        createdOn: Json['createdOn'] as Timestamp? ?? Timestamp.now(),
        updatedOn: Json['updatedOn'] as Timestamp? ?? Timestamp.now(),);
  }
  todo copywith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return todo(
        task: task ?? this.task,
        createdOn: createdOn ?? this.createdOn,
        isDone: isDone ?? this.isDone,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> tojson() {
    return {
      'task': task,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'isDone': isDone
    };
  }
}

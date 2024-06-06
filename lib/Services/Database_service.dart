import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class databaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _todosRef;
  databaseService() {
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<todo>(
        fromFirestore: (snapshot, options) => todo.fromJson(snapshot.data()!),
        toFirestore: (TODO, _) => TODO.tojson());
  }
  Stream<QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(todo Todo) async {
    _todosRef.add(Todo);
  }

  void checkupdate(String todoID, todo Todo) {
    _todosRef.doc(todoID).update(Todo.tojson());
  }

  void deleteTask(String todoID) {
    _todosRef.doc(todoID).delete();
  }
}

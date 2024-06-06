import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Services/Database_service.dart';
import 'package:todo_list/models/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseService _databaseService = databaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: SingleChildScrollView(child: BuildUI()),
      floatingActionButton: FloatingActionButton(
        onPressed: _displaytextinputdilog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget BuildUI() {
    return SafeArea(
        child: Column(
      children: [_messagesList()],
    ));
  }

  Widget _messagesList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: _databaseService.getTodos(),
          builder: (context, snapshot) {
            List todos = snapshot.data?.docs ?? [];
            if (todos.isEmpty) {
              return const Center(
                child: Text("Add a Todo!"),
              );
            }
            print(todos);
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                todo TODO = todos[index].data();
                String TODOID = todos[index].id;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListTile(
                    onLongPress: () => _databaseService.deleteTask(TODOID),
                    tileColor: Colors.amber,
                    title: Text(
                      TODO.task,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(DateFormat("dd-MM-yyyy h:mm a")
                        .format(TODO.createdOn.toDate())),
                    trailing: Checkbox(
                        value: TODO.isDone,
                        onChanged: (value) {
                          todo updatedTODO = TODO.copywith(
                              isDone: !TODO.isDone, updatedOn: Timestamp.now());
                          _databaseService.checkupdate(TODOID, updatedTODO);
                        }),
                  ),
                );
              },
            );
          }),
    );
  }

  void _displaytextinputdilog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add a todo"),
            content: TextField(
                decoration: InputDecoration(hintText: "Todo...."),
                onSubmitted: (value) {
                  if (value.isEmpty) {
                  } else {
                    Navigator.pop(context);
                    return _databaseService.addTodo(
                      todo(
                          task: value,
                          createdOn: Timestamp.now(),
                          isDone: false,
                          updatedOn: Timestamp.now()),
                    );
                    
                  }
                }),
          );
        });
  }
}

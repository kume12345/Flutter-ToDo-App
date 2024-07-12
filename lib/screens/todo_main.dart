import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/shared/app_colors.dart';
import 'package:todo_app/shared/database_helper.dart';

class ToDoMain extends StatefulWidget {
  const ToDoMain({super.key});

  @override
  State<ToDoMain> createState() => _ToDOMainState();
}

class _ToDOMainState extends State<ToDoMain> {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Todo> localToDoList = <Todo>[];
  int count = 0;

  TextEditingController todoItemController = TextEditingController();
  int selectedCategoryId = 0;
  @override
  Widget build(BuildContext context) {
    updateListView();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            "Lets DO It Time Tracker",
            style: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        )),
      ),
      body: Column(
        children: [
          buttonCollection,
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(top:40.0),
            child: getListView(),
          )),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, right: 15),
              child: FloatingActionButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext buildContext) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Please enter your ToDO Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'ToDo description',
                            ),
                            controller: todoItemController,
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: _save,
                            child: const Text('Save'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categooriesTitle = Container(
    margin: const EdgeInsets.only(top: 10),
    child: const Text(
      "Categories",
      style: TextStyle(
        fontSize: 10,
      ),
    ),
  );

  Widget buttonCollection = Container(
    margin: EdgeInsets.only(top: 100 , bottom: 100),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const IconButton.filled(onPressed: null, icon: Icon(Icons.work)),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const Text("Work"),
            )
          ],
        ),
        Column(
          children: [
            IconButton.filled(onPressed: () {}, icon: Icon(Icons.receipt_long)),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const Text("Bills"),
            )
          ],
        ),
        Column(
          children: [
            const IconButton.filled(
                onPressed: null, icon: Icon(Icons.local_grocery_store)),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const Text("Grocerrios"),
            )
          ],
        ),
        Column(
          children: [
            const IconButton.filled(
                onPressed: null, icon: Icon(Icons.list_alt)),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const Text("Other"),
            )
          ],
        )
      ],
    ),
  );

  Widget getListView() {
    Widget listView = ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(localToDoList[index].description),
            value: localToDoList[index].isDone == 1 ? true : false,
            onChanged: (bool? value) {
              setState(() {
                value = !value!;
              });
            },
            secondary: PopupMenuButton(
              onSelected: (int val) async {
                if (val == 0) {
                  showEditDialog(index);
                }
                if(val == 1)
                {
                  deleteToDo(index);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Edit'),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        });
    return listView;
  }

  void _save() async {
    Navigator.pop(context);
    Todo todo =
        Todo(categoryId: 0, isDone: 0, description: todoItemController.text);
    int result = await _databaseService.insertTodo(todo.toMap());
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Contact Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Contact');
    }
    todoItemController.text = "";
  }

  void _updateContact(int index) async {
    Navigator.pop(context);
    Todo todo = localToDoList[index];
    todo.description = todoItemController.text;
    int result = await _databaseService.updateTodo(todo.toMap());
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'ToDo Updated Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Updating ToDo');
    }
  }

  void deleteToDo(int index) async {
    Todo todo = localToDoList[index];
    int? id = todo.id;

    if (id != null) {
      int result = await _databaseService.deleteTodo(id);
      if (result != 0) {
        // Success
        _showAlertDialog('Status', 'ToDo Delted Successfully');
      } else {
        // Failure
        _showAlertDialog('Status', 'Problem Deleting ToDo');
      }
    }
    updateListView();
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void showEditDialog(index) {
    todoItemController.text = localToDoList[index].description;
    Dialog dialog = Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please update todo item details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ToDo description',
              ),
              controller: todoItemController,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => {_updateContact(index)},
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void updateListView() async {
    List<Todo> response = await _databaseService.getTodoList();
    setState(() {
      localToDoList = response;
      count = response.length;
    });
  }
}

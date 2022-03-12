// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_projects/dataabase_helper.dart';
import 'package:flutter_projects/widgets.dart';

import '../models/task.dart';
import '../models/todo.dart';

class Taskpage extends StatefulWidget {
  final Task? task;

  Taskpage({@required this.task});

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskID = 0;
  String _taskTitle = "";
  String _taskDescription = "";
  String _todoText = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;


  @override
  void initState() {
    if (widget.task != null) {
      //set the visibility to true
      _contentVisible = true;

      _taskTitle = widget.task?.title ?? "Unnamed Task";
      _taskDescription = widget.task?.description??"Unnamed Desc";
      _taskID = widget.task?.id?? 1 ;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 25.0,
                    bottom: 3.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image(
                            image:
                                AssetImage("assets/images/back_arrow_icon.png"),
                          ),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          print("Field Value: $value");
                          // check if the task is not empty
                          if (value != "") {
                            //check if the task is null
                            if (widget.task == null) {
                              Task _newtask = Task(title: value);

                              _taskID = await _dbHelper.insertTask(_newtask);
                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                            } else {
                              await _dbHelper.updateTaskTitle(_taskID, value);
                            }
                            print("Task Updated");

                            _descriptionFocus?.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle,
                        decoration: InputDecoration(
                          hintText: "Enter Task Title...",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF362706),
                        ),
                      )),
                    ],
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      focusNode: _descriptionFocus,
                      onSubmitted: (value) async {
                        if(value!= ""){
                          if(_taskID!=0){
                            await _dbHelper.updateTaskDescription(_taskID, value);
                            _taskDescription = value;
                          }
                        }
                        _todoFocus?.requestFocus();
                      },
                      controller: TextEditingController()..text = _taskDescription,
                      decoration: InputDecoration(
                          hintText: "Enter description of task... ",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskID),
                    builder: (context, AsyncSnapshot snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if(snapshot.data[index].isDone == 0){
                                  await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                } else{
                                  await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                }
                                setState(() {});
                              },
                              child: TodoWidget(
                                text:snapshot.data[index].title,
                                isDone: snapshot.data[index].isDone == 0 ? false : true,
                              ),
                            );
                          }
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 25.0,
                          margin: EdgeInsets.only(
                            right: 16.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: Color(0xFF444d2a),
                                width: 1.5,
                              )),
                          child: Image(
                            image: AssetImage("assets/images/check_icon.png"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _todoFocus,
                            controller: TextEditingController()..text = "",
                            onSubmitted: (value) async {
                              // check if the task is not empty
                              if (value != "") {
                                //check if the task is null
                                if (_taskID != 0) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Todo _newtodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskID: _taskID);
                                  await _dbHelper.insertTodo(_newtodo);
                                  setState(() {});
                                  _todoFocus?.requestFocus();
                                } else {
                                  print("Task doesn't exist");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter To-Do item...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 15.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () async {
                    if(_taskID !=0){
                      await _dbHelper.deleteTask(_taskID);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xE9465804),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        "assets/images/delete_icon.png",
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

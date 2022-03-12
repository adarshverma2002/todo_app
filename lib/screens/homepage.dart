// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_projects/dataabase_helper.dart';
import 'package:flutter_projects/screens/taskpage.dart';
import 'package:flutter_projects/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 18.0,
        ),
        color: Color(0XFFeae6d7),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 28.0,
                  ),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    initialData: [],
                    future: _dbHelper.getTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        if (data != null) {
                          return ScrollConfiguration(
                            behavior: NoGlowBehavior(),
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                          task: snapshot.data?[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data?[index].title,
                                    desc: snapshot.data ?[index].description,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                      return TaskCardWidget();
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 15.0,
              right: 10.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Taskpage(
                              task: null,
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFceab93), Color(0xFFad8b73)],
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image(
                    image: AssetImage(
                      "assets/images/add_icon.png",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

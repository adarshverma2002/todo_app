// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;
  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "Unnamed Task",
            style: TextStyle(
              color: Color(0xFF332201),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "No description",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF332201),
                height: 1.5,

              ),
            ),
          )
        ],
      )
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  TodoWidget({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical:8.0,
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
              color: isDone ? Color(0xFFadba93) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(
                color: Color(0xFF444d2a),
                width: 1.5,
              )
            ),
            child: Image(
              image: AssetImage(
                "assets/images/check_icon.png"
              ),
            ),
          ),
          Flexible(
            child: Text(
                text ?? "(Unnamed To-Do)",
              style: TextStyle(
                color: isDone ? Color(0xFF444d2a) : Color(0xff9a8c44),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                decoration: isDone? TextDecoration.lineThrough: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

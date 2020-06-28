import 'package:flutter/material.dart';

class DragAndDropPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: App(),
      )
    );
  }
}


class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DragBox(Offset(0.0, 0.0), Colors.lime, 'Box One'),
        DragBox(Offset(100.0, 0.0), Colors.orange, 'Box two'),
        Positioned(
          left: 100,
          bottom: 0.0,
          child: DragTarget(
            onAccept: (Color color){
              caughtColor = color;
            },
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected
              ) {
                return Container(
                  width: 200,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text("Drag here"),
                  ),
                );
              }
          ),
        )
      ],
    );
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  DragBox(this.initPos, this.itemColor, this.label);


  @override
  _DragBoxState createState() => _DragBoxState();
}

class _DragBoxState extends State<DragBox> {

  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    position = widget.initPos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        data: widget.itemColor,
        child: Container(
          width: 100.0,
          height: 100.0,
          color: widget.itemColor,
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
              fontSize: 20.0,
            ),
          ),
        ),

        onDraggableCanceled: (velocity, offset){
          setState(() {
            position = offset;
          });
        },

        feedback: Container(
          width: 120.0,
          height: 120.0,
          color: widget.itemColor.withOpacity(0.5),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


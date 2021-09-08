import 'package:flutter/material.dart';
import 'package:task_graph/DM_interface.dart';
import 'package:task_graph/data_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boards = [mockBoard];
  Board activeBoard = mockBoard; //temporary solution
  late Node mockGoal = activeBoard.addGoal('mockGoal');
  late Node mockStep = activeBoard.addStepByAim('Mock Step', mockGoal);
  bool isTitleClicked = false;
  late Function changeTitleMode = () {
    setState(() {
      isTitleClicked = !isTitleClicked;
    });
  };
  late Function changeActiveBoardTitle = (String value) {
    setState(() {
      activeBoard.title = value;
    });
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("placeholder for a feature (map graph)")));
              },
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.menu_open),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("a menu should open")));
            }, //TODO: implement menu for boards
          ),
          title: ResponsiveTitle(
            board: activeBoard,
            isInEditingMode: isTitleClicked,
            changeModeCallback: changeTitleMode,
            changeActiveBoardTitleCallback: changeActiveBoardTitle,
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'The active board:',
            ),
            Text(
              '${activeBoard.title} , ${mockStep.title}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openNodePage(context, mockStep);
        },
        tooltip: 'open step description',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ResponsiveTitle extends StatelessWidget {
  final Board board;
  bool isInEditingMode;
  final Function changeModeCallback;
  final Function changeActiveBoardTitleCallback;
  ResponsiveTitle(
      {Key? key,
      required this.board,
      required this.isInEditingMode,
      required this.changeModeCallback,
      required this.changeActiveBoardTitleCallback})
      : super(key: key);
  late TextEditingController controller =
      TextEditingController(text: board.title);

  @override
  Widget build(BuildContext context) {
    if (isInEditingMode) {
      return TextField(
        controller: controller,
        autofocus: true,
        autocorrect: false,
        onSubmitted: (value) {
          changeActiveBoardTitleCallback(value);
          changeModeCallback();
        },
      );
    }
    return GestureDetector(
      child: Text(board.title),
      onTap: () {
        changeModeCallback();
      },
    );
  }
}

void openNodePage(BuildContext context, Node node) {
  showDialog(
      context: context, builder: (BuildContext context) => NodePage(node));
}

class NodePage extends StatelessWidget {
  final Node node;
  NodePage(this.node);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width / 2, size.height / 2);
    return Center(
        child: Container(
      color: Colors.blue,
      height: size.height,
      width: size.width,
      child: Column(
        //rearrange neatly
        children: [
          Text(
            node.title,
            style: TextStyle(color: Colors.white),
          ),
          Text(node.description),
          for (Node aim in node.aim)
            TextButton(
                onPressed: () {
                  openNodePage(context, aim);
                },
                style: ButtonStyle(),
                child: Text(
                  aim.title,
                  style: TextStyle(color: Colors.white),
                ))
        ],
      ),
    ));
  }
}

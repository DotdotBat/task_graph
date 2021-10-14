import 'dart:collection' show Queue;
//never let there be a loop
//TODO: create a function to show all ultimate goals of a task
class Board {
  int allTimeNodeCount = 0;
  String title = 'unnamed board';
  Map<int, Node> map = {};
  Board(this.title);

  Node addGoal(String title) {
    int id = ++allTimeNodeCount;
    this.map[id] = Goal(id, title);
    return this.map[id]!;
  }

  Node addStep(String title) {
    var step = Step(++allTimeNodeCount, title);
    this.map[step.id] = step;
    return this.map[step.id]!;
  }

  Node addStepByAim(String title, Node aim) {
    var step = this.addStep(title);
    step.aim.add(aim);
    aim.prerequisites.add(step);
    return step;
  }

  List<Node> unlocked() {
    List<Node> result = [];
    for (Node node in this.map.values) {
      if (node.prerequisites.isEmpty) {
        result.add(node);
      }
    }
    return result;
  }

  void deleteNode(Node node) {
    void cleanAim() {
      for (Node aim in node.aim) {
        aim.prerequisites.remove(node);
      }
    }

    void cleanPrerequisites() {
      for (Node pre in node.prerequisites) {
        pre.aim.remove(node);
      }
    }

    void deleteTheNode() {
      this.map.remove(node.id);
    }

    cleanAim();
    cleanPrerequisites();
    deleteTheNode();
  }

  void clearNode(Node node) {
    bool unlocked = this.unlocked().contains(node);

    if (unlocked) {
      deleteNode(node);
    } else {
      throw Exception('tried to clear an unlocked node(${node.title})');
    }
  }

  void connectNodes(Node prerequisite, Node aim) {
    prerequisite.aim.add(aim);
    aim.prerequisites.add(prerequisite);
  }

  void disconnectNodes(Node node1, Node node2) {
    //this way we don't care about the order
    // no else structure for 2-node-cycle case
    //for optimization try without if statements.
    if (node1.aim.remove(node2)) {
      node2.prerequisites.remove(node1);
    }
    if (node2.aim.remove(node1)) {
      node1.prerequisites.remove(node2);
    }
  }

  factory Board.fromBoard(Board board) {
    Board copy = Board(board.title);
    copy.allTimeNodeCount = board.allTimeNodeCount;
    for (int id in board.map.keys) {
      if (board.map[id].runtimeType == Step) {
        copy.map[id] = Step(id, board.map[id]!.title);
      } else {
        copy.map[id] = Goal(id, board.map[id]!.title);
      }
    }
    for (int id in board.map.keys) {
      for (Node prerequisite in board.map[id]!.prerequisites) {
        copy.connectNodes(copy.map[prerequisite.id]!, copy.map[id]!);
      }
    }
    return copy;
  }

  bool isClearable() {
    Board copy = Board.fromBoard(this);
    while (copy.unlocked().isNotEmpty) {
      var unlocked = copy.unlocked();
      for (Node node in unlocked) {
        copy.clearNode(node);
      }
    }
    return copy.map.isEmpty;
  }

  ///Returnes an unorderd list of the nodes, that form a cycle. Or an empty list.
  List<Node> cycleMembers() {
    Board copy = Board.fromBoard(this);
    List<Node> collectDeadEnds() {
      List<Node> result = [];
      for (Node node in copy.map.values) {
        if (node.aim.isEmpty || node.prerequisites.isEmpty) {
          result.add(node);
        }
      }
      return result;
    }

    bool goAgain = true;
    while (goAgain) {
      List<Node> deadEnds = collectDeadEnds();
      goAgain = deadEnds.isNotEmpty;
      for (Node node in deadEnds) {
        copy.deleteNode(node);
      }
    }
    return copy.map.values.toList();
  }

  void insertNode(Node prerequisite, Node inserted, Node aim) {
    disconnectNodes(prerequisite, aim);
    connectNodes(prerequisite, inserted);
    connectNodes(inserted, aim);
  }

  void connectManyNodes(Map<Node, List<Node>> connectScheme) {
    for (Node aim in connectScheme.keys) {
      for (Node prerequisite in connectScheme[aim]!) {
        connectNodes(prerequisite, aim);
      }
    }
  }

  bool areNodesConnectedIndirectly(Node node1, Node node2) {
    Set<Node> visited = {};
    Queue<Node> toVisit =  Queue<Node>();
    toVisit.add(node1);
    while(toVisit.isNotEmpty){
      Node visiting = toVisit.removeFirst();
      visited.add(visiting);
      List<Node> adjacentNodes = [...visiting.aim, ...visiting.prerequisites];
      for (Node node in adjacentNodes){
        if (!visited.contains(node)){
          if (node == node2){return true;}
          if(!toVisit.contains(node)){toVisit.add(node);}
        }
      }
    }
    
    return false;
  }
}

abstract class Node {//TODO: this abstract class is redundant 
  int id;
  String title;
  String description = 'Description';
  Set<Node> aim = {};
  Set<Node> prerequisites = {};
  Node(this.id, this.title);
  @override
  String toString() {//TODO: json
    String result = '';
    if (this.runtimeType == Goal) {
      result = result + 'Goal: ';
    }
    if (this is Step) {
      result = result + 'Step: ';
    }
    result = result + '${this.id} ';
    result = result + this.title;
    return result;
  }
}

//for now there is no difference between goal and step
//they will be different when priority is implemented.
//no, I will not use steps with no aim as goal
//they may be the result of tearing, or else.
//so keep them seperate
class Goal extends Node {
  Goal(int id, String title) : super(id, title);
}

class Step extends Node {
  Step(int id, String title) : super(id, title);
}


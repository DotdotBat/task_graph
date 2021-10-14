import 'package:task_graph/data_model.dart';
import 'package:test/test.dart';
main(){
  
  group('init ', () {

    test('create board', (){
      String boardTitle = 'TaskGraph App';
  Board board = Board(boardTitle);
  expect(board.title, boardTitle);
  expect(board.allTimeNodeCount, 0);
    });
    
  });

   group('goal behavior', (){//TODO: before modifing data model transfer tests

   });
  group('step behavior', (){

   });


group('cycle detection', (){

   });

group('something else', (){

   });
}


/*
  String boardTitle = 'TaskGraph App';
  Board board = Board(boardTitle);
  ass(board.title == boardTitle, 'first board is created');
  ass(board.AllTimeNodeCount == 0, 'nodecount starts from 0');
  String goalTitle = 'Build an graph To-Do app';

  int firstGoalId = 1;
  Node goal = board.addGoal(goalTitle);
  ass(goal.runtimeType == Goal, 'add goal returns id');
  ass(board.AllTimeNodeCount == 1, 'nodecount went up after adding goal');

  ass(goal.title == goalTitle, 'the name of the retrived goal did not change');
  ass(goal.runtimeType == Goal, 'retrived by id node is of type Goal');
  String firstStepTitle = 'Graph Data Model';

  ass(board.addStepByAim(firstStepTitle, goal).runtimeType == Step,
      'add a step to the goal');

  int firstStepId = 2;
  Node modelStep = board.map[firstStepId]!;
  ass(modelStep.title == firstStepTitle,
      'retrived by id step retained the title');
  ass(modelStep.runtimeType == Step, 'retrived by id step is of type Step');
  ass(modelStep.aim.single.id == firstGoalId, 'aim in retrived step');
  ass(board.unlocked().single == modelStep,
      'in board.unlocked expected ${[modelStep]} but got ${board.unlocked()}');

  ass(goal.prerequisites.isNotEmpty,
      'local variable is updated when state changes');
  //it seems that there is no reason to update the local reference
  //to one of the map values.
  //the local reference is not a copy
  String secondStepTitle = 'Storage metod';
  Node storageStep = board.addStepByAim(secondStepTitle, goal);

  ass(storageStep.toString() != modelStep.toString(),
      'Node.toString metod for different titled nodes');
  Node thirdStep = board.addStepByAim(secondStepTitle, goal);
  ass(storageStep.toString() != thirdStep.toString(),
      'Node.toString metod for same titled nodes');
  ass(board.unlocked().first != storageStep,
      'checking if the equality check is valid');
  board.clearNode(thirdStep);
  ass(board.unlocked().length == 2,
      'there should be only two Steps in the unlocked list not ${board.unlocked().length}');

  board.connectNodes(modelStep, storageStep);
  ass(board.unlocked().length == 1,
      'there should be only on step in the unlocked list not ${board.unlocked().length}');

  var boardCopy = Board.fromBoard(board);
  boardCopy.title = 'copy';
  ass(board.title != boardCopy.title, 'board copy metod ');

  ass(board.isClearable(), 'board.isClearable');
  Board dummyBoard = Board('existancial crisis');
  Node moneyGoal = dummyBoard.addGoal('get money');
  Node workStep = dummyBoard.addStepByAim('get work', moneyGoal);
  Node expStep = dummyBoard.addStepByAim('get experience', workStep);
  Node uniStep = dummyBoard.addStepByAim('university', expStep);
  Node schoolStep = dummyBoard.addStepByAim('school', uniStep);
  dummyBoard.addStepByAim('money', uniStep);
  Node beGoodStep = dummyBoard.addStep('be a good person');

  dummyBoard.connectNodes(workStep, expStep);
  ass(!dummyBoard.isClearable(), 'this dummy tactics should not work');
  ass(dummyBoard.cycleMembers().length == 2, 'cycle of two nodes');
  board.disconnectNodes(modelStep, storageStep);
  ass(board.unlocked().length == 2,
      'after disconnecting nodes 2 unlocked nodes');
  Node jsonStep = board.addStep('implement Json metod for storage');
  board.insertNode(modelStep, jsonStep, storageStep);
  ass(jsonStep.aim.single == storageStep, 'connection after inserting a step');
  ass(modelStep.aim.contains(jsonStep), 'connection after inserting a step');
  ass(!modelStep.aim.contains(storageStep),
      'lost direct connection after inserting');
  Map<Node, List<Node>> patchScheme = {
    storageStep: [modelStep]
  };
  ass(board.unlocked().length == 1, 'after inserting a node 1 unlocked node');

  board.deleteNode(jsonStep);
  ass(board.unlocked().length == 2,
      'after deleting inserted node 2 unlocked nodes');
  board.connectManyNodes(patchScheme);
  ass(board.unlocked().length == 1, 'after patching, 1 unlocked node');

  ass(!dummyBoard.areNodesConnectedIndirectly(moneyGoal, beGoodStep),
      'money and being a good person are not connected');
  ass(dummyBoard.areNodesConnectedIndirectly(schoolStep, workStep),
      'school and work are connected');


*/
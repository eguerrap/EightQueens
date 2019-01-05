import 'package:flutter/material.dart';
import 'package:eqapp/Logic/Common.dart';
import 'package:eqapp/Logic/Solution.dart';
import 'package:eqapp/Logic/EightQueens.dart';
import 'package:eqapp/Screen/AlertBox.dart';
import 'package:eqapp/Screen/ChessBoardWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();

  int NoQueens;
  int SizeChessBoard;
  List CurrentSolution;
  List<Solution> CurrentSolutionList;
  int CurrentSolutionIndex = 0;
  int SolutionCount = 0;


  bool Validate(){
    bool Result = true;

    if(NoQueens>SizeChessBoard){
      Result = false;
      AlertBox.Alert(context, "The number of queens can not be greater than the size of the board :(");
    }
    if(NoQueens==1){
      Result = false;
      AlertBox.Alert(context, "The queen can be anywhere :(");
    }
    if(SizeChessBoard<4){
      Result = false;
      AlertBox.Alert(context, "Let's go! we can do better, try with a board greater than 3");
    }
    return Result;
  }

  void Back(){
    CurrentSolutionIndex--;
    if(CurrentSolutionIndex<1){CurrentSolutionIndex=1;}
    CurrentSolution = CurrentSolutionList[CurrentSolutionIndex-1].SolutionBoard;

  }

  void Next(){
    CurrentSolutionIndex++;
    if(CurrentSolutionIndex>SolutionCount){CurrentSolutionIndex=SolutionCount;}
    CurrentSolution = CurrentSolutionList[CurrentSolutionIndex-1].SolutionBoard;
  }

  void Resolve(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      if(Validate()){
        setState(() {
          var Play = new EightQueens(NoQueens, SizeChessBoard);
          Play.Resolve();
          CurrentSolutionList = Play.Solutions;
          SolutionCount = CurrentSolutionList.length;
          AlertBox.Alert(context, "$SolutionCount solutions found!");
          CurrentSolutionIndex =0;
          if(SolutionCount>0)Next();
        });
      }
    }
  }

  void onTapSolution(int index) {
    setState(() {
      if(CurrentSolution!=null && CurrentSolution.length>0){
        if(index==0)Back();
        if(index==2)Next();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eight Queens App"),
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
          child:Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(
                    children: [
                      Container(
                        color: Colors.blue,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "No. Queens"
                          ),
                          onSaved: (value) => NoQueens = int.parse(value),
                          validator: (value)=> !Tool.IsNumeric(value)?"Please write a number":null,
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Size ChessBoard"
                          ),
                          onSaved: (value) => SizeChessBoard = int.parse(value),
                          validator: (value)=> !Tool.IsNumeric(value)?"Please write a number":null,
                        ),
                      ),
                    ]
                  )
                ],
              ),
              Expanded(
                child: ChessBoardWidget(context, NoQueens, SizeChessBoard, CurrentSolution, CurrentSolutionIndex)
              )
            ],
          )
      ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTapSolution,
            currentIndex: 0,
            items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fast_rewind),
            title: Text("Back")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text("$CurrentSolutionIndex/$SolutionCount")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.fast_forward),
              title: Text("Next")
          )
        ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: Resolve,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:eqapp/Logic/Common.dart';

class ChessBoardWidget extends StatelessWidget {
  int NoQueens;
  int SizeBoard;
  int NoSolution;
  List Solution;
  BuildContext context;

  ChessBoardWidget(this.context,  this.SizeBoard, this.NoQueens, this.Solution, this.NoSolution);

  Color GetColorSquare(int i, int j){
    Color Result = Colors.amberAccent;

    if (i % 2 != 0 && j % 2 != 0 || i % 2 == 0 && j % 2 == 0) {
      Result = Colors.amberAccent;
    } else {
      Result = Colors.orangeAccent;
    }
    return Result;
  }

  List<TableRow> TRow(){
    List<TableRow> Result = new List<TableRow>();
    List<Widget> Columns;
    double SizeLogicBoard = MediaQuery.of(context).size.width;
    double SizeLogicSquare = 0.0;
    if(Solution!=null && Solution.length>0){

      SizeLogicSquare = (SizeLogicBoard/SizeBoard);

      Solution.forEach((b)
      {
        Columns = new List<Widget>();

        b.forEach((c){

          String T = c[2]==SquareState.queen?"Q":"";
          Columns.add(
              Container(
                alignment: Alignment(0.0, 0.0),
                width: SizeLogicSquare,
                height: SizeLogicSquare,
                color: GetColorSquare(c[0], c[1]),
                child: Text(T, textAlign: TextAlign.center),
              )
          );
        });//Columns

        Result.add(
            TableRow(
                children: Columns
            )
        );
      });
    }

    return Result;
  }


  Widget Show(){
    Widget Result = null;
    if(Solution!=null&&Solution.length>0){
      Result = Column(
        children: <Widget>[
          Text("Solution No. $NoSolution"),
          Table(
            children: TRow(),
          )
        ],
      );
    }
    return Result;
  }

  @override
  Widget build(BuildContext context){
    return Card(
      child: Show(),
    );
  }
}
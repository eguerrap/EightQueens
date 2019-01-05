import 'package:eqapp/Logic/Common.dart';
import 'package:eqapp/Logic/ChessBoard.dart';
import 'package:eqapp/Logic/Solution.dart';


class EightQueens
{
  int SizeBoard;
  int NoQueen;
  ChessBoard MyBoard;
  List<Solution> Solutions;
  List Tracking;

  EightQueens(this.NoQueen, this.SizeBoard){
    MyBoard = new ChessBoard(SizeBoard);
    Solutions = new List<Solution>();
    Tracking = List.generate(NoQueen, (i)=>[i,-1]);
  }

  void BackTraking(int index){
    MyBoard.LoadBoard();
    Tracking
        .where((t)=>t[0]<index)
        .where((a)=>a[1]>-1)
        .forEach((s){
      MyBoard.QueenMovemment(s[0],s[1]);
    });
    Tracking.where((t)=>t[0]>index).forEach((v){
      Tracking[v[0]][1] = -1;
    });
  }

  int MoveNext(int queen){
    int Result = -1;
    BackTraking(queen);
    var y = queen;
    var x = Tracking[queen][1];
    int CheckSquare = MyBoard.Vector
        .where((c)=> c[0] == y && c[2] == SquareState.check).length;
    if(CheckSquare<SizeBoard){
      Result = 0;
      var Candidate = MyBoard.Vector.firstWhere((c)=>
      c[0] == y &&
          c[1]>x &&
          c[2] == SquareState.empty,
          orElse:()=> null);
      if(Candidate!=null) {x = Candidate[1]; Result = 1; }
      Tracking[queen][1] = x;
      MyBoard.QueenMovemment(y,x);
    }
    return Result;
  }

  void Resolve(){

    var r=0;
    var a = false;
    var q = 0;
    do{

      var T = MoveNext(q);
      if(T==1){
        q=(q==(NoQueen-1)?q-1:q+1);
      }
      else if (T==-1)
      {
        q = q-1;
      } else if (T==0)
      {
        if(T==0 && q==0 && Tracking[0][1]==(SizeBoard-1))
        {
          a=true;
        }
        q = q-1;
      }
      if(NoQueen==MyBoard.QueenInBoard){
        r++;
        SaveSolution(r);
      }
    }while(!a);
  }

  bool GetForPosition(int y, int x){
    bool Result = false;
    bool Terminate = false;
    MyBoard.QueenMovemment(y,x);

    do{
      if(MyBoard.EmptySquare>0){
        var Candidate = MyBoard.Vector.firstWhere((c)=> c[2] == SquareState.empty, orElse:()=> null );     			 MyBoard.QueenMovemment(Candidate[0],Candidate[1]);
      }
      else{
        Terminate = true;
      }
      if(NoQueen==MyBoard.QueenInBoard){
        Terminate = true;
        Result = true;
      }

    }
    while(!Terminate);

    return Result;
  }

  void SaveSolution(int index){
    Solutions.add(new Solution(index, MyBoard.Board));
  }

  //Only for Console Version
  void PrintSolutions(){
    print("N Queens: ${NoQueen}, Size Board: ${SizeBoard}");
    print("Solutions found: ${Solutions.length}");
    Solutions.forEach((s)=>PrintBoard(s));
  }

  //Only for Console Version
  void PrintBoard(Solution solution){
    print("Solution ${solution.Index}");
    String cmdBoardPrint = "";
    solution.SolutionBoard.forEach((b)
    {
      cmdBoardPrint = "|";
      b.forEach((c){
        switch(c[2]){
          case SquareState.empty :
            cmdBoardPrint = cmdBoardPrint + "_";
            break;
          case SquareState.check :
            cmdBoardPrint = cmdBoardPrint + ".";
            break;
          case SquareState.queen :
            cmdBoardPrint = cmdBoardPrint + "Q";
            break;
        }
        cmdBoardPrint = cmdBoardPrint + "|";
      });
      print(cmdBoardPrint);
    });
  }

  //Only for Console Version
  void PrintCurrentBoard(){

    String cmdBoardPrint = "";
    MyBoard.Board.forEach((b)
    {
      cmdBoardPrint = "|";
      b.forEach((c){
        switch(c[2]){
          case SquareState.empty :
            cmdBoardPrint = cmdBoardPrint + "_";
            break;
          case SquareState.check :
            cmdBoardPrint = cmdBoardPrint + ".";
            break;
          case SquareState.queen :
            cmdBoardPrint = cmdBoardPrint + "Q";
            break;
        }
        cmdBoardPrint = cmdBoardPrint + "|";
      });
      print(cmdBoardPrint);
    });
  }
}
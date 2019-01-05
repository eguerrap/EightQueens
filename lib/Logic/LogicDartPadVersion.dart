void main() {
  EightQueens Tmp = new EightQueens(8,8);
  Tmp.Resolve();
  Tmp.PrintSolutions();
}

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

enum SquareState{
  empty, queen, check
}

class Solution{
  int Index;
  List SolutionBoard;
  Solution(this.Index, this.SolutionBoard);
}

class ChessBoard{
  int SizeBoard;
  int QueenInBoard;
  int EmptySquare;
  List Vector;
  List Board;

  ChessBoard(this.SizeBoard){
    LoadBoard();
  }

  void LoadBoard(){
    Board = List.generate(SizeBoard,
            (a)=>List.generate(SizeBoard,
                (i)=>[a, i, SquareState.empty]));
    SetVector();
  }

  void SetVector(){
    Vector = Board.expand((f) => f).toList();
    EmptySquare = Vector.where((c)=> c[2] == SquareState.empty).toList().length;
    QueenInBoard = Vector.where((c)=> c[2] == SquareState.queen).toList().length;
  }

  void QueenMovemment(y,x){
    var ddy = y-1;
    var ddr = x+1;
    var ddl = x-1;
    var dar = x+1;
    var dal = x-1;
    Board[y].forEach((c){
      Board[y][c[1]][2] = SquareState.check;
    });
    Board[x].forEach((c){
      Board[c[1]][x][2] = SquareState.check;
      if(c[1]<y){
        if(ddy>=0){
          if(ddr>=0&&ddr<=(SizeBoard-1))Board[ddy][ddr][2] = SquareState.check;
          if(ddl>=0)Board[ddy][ddl][2] = SquareState.check;
        }
        ddy--;
        ddl--;
        ddr++;
      }
      if(c[1]>y){
        if(dar<=(SizeBoard-1))Board[c[1]][dar][2] = SquareState.check;
        if(dal>=0)Board[c[1]][dal][2] = SquareState.check;
        dal--;
        dar++;
      }
    });
    Board[y][x][2] = SquareState.queen;
    SetVector();
  }

}
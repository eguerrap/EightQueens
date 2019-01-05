import 'package:eqapp/Logic/Common.dart';

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
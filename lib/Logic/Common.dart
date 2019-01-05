enum SquareState{
  empty, queen, check
}


class Tool{

  static  IsNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
// ignore_for_file: avoid_print

import "package:enumset/enumset.dart";

enum Suits {spades, clubs, hearts, diamonds}

void main() {
  final EnumSet<Suits> reds = EnumSet(Suits.values)
    ..addAll([Suits.hearts, Suits.diamonds]);
  // Suits.spades   = 0001 = 1
  // Suits.clubs    = 0010 = 2
  // Suits.hearts   = 0100 = 4
  // Suits.diamonds = 1000 = 8

  print(reds);  // "Suits 1100"
  // Adds the bits of hearts and diamonds together: 
  //
  //   0100 = 4 (hearts)
  // | 1000 = 8 (diamonds)
  // ------
  //   1100 = 12 (hearts + diamonds)

  print(reds.contains(Suits.spades));  // false
  // Performs an AND operation:
  //
  //   1100 = 12 (hearts + diamonds)
  // & 0001 = 1 (spades)
  // ------
  //   0000 = 0 (false)

  print(reds.contains(Suits.hearts));  // true
  //   1100 = 12 (hearts + diamonds)
  // & 0100 = 4 (hearts)
  // ------
  //   0100 = 4 (hearts)

  reds.remove(Suits.hearts);
  // performs AND with NOT: 
  // 
  // ~0100 = 1011 (not hearts)
  // 
  //   1100 = 12 (hearts + diamonds)
  // & 1011 = 11 (-hearts)
  // ------
  //   1000 = 8 (diamonds)
}

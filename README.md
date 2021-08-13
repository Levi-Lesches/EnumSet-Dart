A Dart implementation of Java's [EnumSet](https://docs.oracle.com/javase/8/docs/api/java/util/EnumSet.html) (or bit fields).

Stores values by assigning a power-of-two value to each one and doing bitwise operations on integers. 

```dart
import "package:enumset/enumset.dart";

enum Suits {spades, clubs, hearts, diamonds}

void main() {
  final EnumSet<Suits> reds = EnumSet(Suits.values);
  // Suits.spades   = 0001 = 1
  // Suits.clubs    = 0010 = 2
  // Suits.hearts   = 0100 = 4
  // Suits.diamonds = 1000 = 8

  reds.addAll([Suits.hearts, Suits.diamonds]);
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
```

## Usage

Use this as you would a `Set` of enum values. The only difference is you must first create it by passing in all possible values.

```dart
import "package:enumset/enumset.dart";

enum Suits {spades, clubs, hearts, diamonds}

void main() {
  final EnumSet<Suits> reds = EnumSet(Suits.values);  // empty
  print(reds.contains(Suits.spades));  // false
  print(reds.contains(Suits.hearts));  // false (it's empty)

  reds.addAll([Suits.hearts, Suits.diamonds]);
  print(reds.contains(Suits.spades));  // false
  print(reds.contains(Suits.hearts));  // true

  // Of course, you could also do this:
  final Set<Suits> blacks = {Suits.spades, Suits.clubs};
  print(blacks.contains(Suits.spades));  // true
  print(blacks.contains(Suits.hearts));  // false
}
```

You should probably just use `Set`. This is just for people interested in bit fields, since it's technically more memory-efficient.
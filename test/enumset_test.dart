import "package:enumset/enumset.dart";
import "package:test/test.dart";

enum Suits {spades, clubs, hearts, diamonds}
enum Colors {red, green, blue, yellow}

void main() {
  test("toString() test", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values);
    expect(reds.toString(), equals("Suits 0"));
    expect(reds.copy().toString(), equals("Suits 0"));

    reds.add(Suits.spades);
    expect(reds.toString(), equals("Suits 1"));

    reds..add(Suits.hearts)..add(Suits.diamonds);
    expect(reds.toString(), equals("Suits 1101"));
  });

  test("Equality", () {
    // Empty sets are equal
    final EnumSet<Suits> reds = EnumSet(Suits.values);
    final EnumSet<Suits> blacks = EnumSet(Suits.values);
    final EnumSet<Suits> reversed = EnumSet([
      Suits.diamonds, Suits.hearts, Suits.clubs, Suits.spades,
    ]);
    expect(reds.copy(), equals(reds));  // copy
    expect(reds, equals(blacks));  // equal sets
    expect(reds, equals(reds));  // identical
    expect(reds, isNot(equals(reversed)));  // order matters

    // Adding elements makes a difference
    reds.addAll([Suits.hearts, Suits.diamonds]);
    blacks.addAll([Suits.spades, Suits.clubs]);
    expect(reds, isNot(equals(blacks)));

    // Manual creation does not matter.
    final EnumSet<Suits> reds2 = EnumSet(Suits.values)
      ..addAll([Suits.hearts, Suits.diamonds]);
    expect(reds, equals(reds2));
  });

  test("Operator []", () {
    final EnumSet<Suits> suits1 = EnumSet(Suits.values);
    expect(suits1[Suits.spades], equals(1));
    expect(suits1[Suits.clubs], equals(2));
    expect(suits1[Suits.hearts], equals(4));  
    expect(suits1[Suits.diamonds], equals(8));

    final EnumSet<Suits> suits2 = EnumSet([
      Suits.diamonds, Suits.hearts, Suits.clubs, Suits.spades,
    ]);
    expect(suits2[Suits.spades], equals(8));
    expect(suits2[Suits.clubs], equals(4));
    expect(suits2[Suits.hearts], equals(2));  
    expect(suits2[Suits.diamonds], equals(1));
  });

  test("Hashing", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values)
      ..addAll([Suits.hearts, Suits.diamonds]);
    final EnumSet<Suits> reds2 = reds.copy();
    final EnumSet<Suits> blacks = EnumSet(Suits.values)
      ..addAll([Suits.spades, Suits.clubs]);
    final EnumSet<Colors> colors = EnumSet(Colors.values)
      ..addAll([Colors.red, Colors.green]);  // same bit value
    final Map<EnumSet, String> sets = {
      reds: "Should not appear",
      reds2: "reds",  // equal to reds
      blacks: "blacks",  // same flags as reds
      colors: "colors",  // same bits as blacks
    };

    expect(colors.bits, equals(blacks.bits));
    expect(sets[reds], equals("reds"));
    expect(sets[reds2], equals("reds"));
    expect(sets[blacks], equals("blacks"));
    expect(sets[colors], equals("colors"));

    expect(reds.hashCode, equals(reds2.hashCode));
    expect(reds.hashCode, isNot(equals(colors.hashCode)));

    // Equal flags, different hash codes
    expect(reds.flags, equals(blacks.flags));
    expect(reds.hashCode, isNot(equals(blacks.hashCode)));
    expect(reds, isNot(equals(blacks)));

    // Equal bits, different hash codes
    expect(blacks.bits, equals(colors.bits));
    expect(blacks.hashCode, isNot(equals(colors.hashCode)));
    expect(blacks, isNot(equals(colors)));
  });

  test("Add all", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values);
    final EnumSet<Suits> reds2 = reds.copy();

    reds.addAll([Suits.hearts, Suits.diamonds]);
    reds2..add(Suits.hearts)..add(Suits.diamonds);
    expect(reds, equals(reds2));
  });

  test("Add and remove", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values);

    expect(reds.bits, equals(0));  // empty

    reds.add(Suits.hearts);
    expect(reds.bits, equals(4));  // add hearts = 4

    reds.add(Suits.spades);
    expect(reds.bits, equals(5));  // add spades = 1

    reds.remove(Suits.spades);
    expect(reds.bits, equals(4));  // remove spades = 1

    reds.remove(Suits.clubs);
    expect(reds.bits, equals(4));  // remove clubs (not in set)

    reds.remove(Suits.hearts);
    expect(reds.bits, equals(0));  // remove hearts = 4

    reds.remove(Suits.hearts);
    expect(reds.bits, equals(0));  // remove hearts (not in set)
  });

  test("Contains", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values);

    expect(reds.contains(Suits.spades), isFalse);
    expect(reds.contains(Suits.hearts), isFalse);

    reds.add(Suits.hearts);
    expect(reds.contains(Suits.spades), isFalse);
    expect(reds.contains(Suits.hearts), isTrue);  // added

    reds.remove(Suits.hearts);
    expect(reds.contains(Suits.spades), isFalse);
    expect(reds.contains(Suits.hearts), isFalse);  // removed
  });

  test("toList()", () {
    final EnumSet<Suits> reds = EnumSet(Suits.values);
    expect(reds.toSet(), isEmpty);

    reds.add(Suits.hearts);
    expect(reds.toSet(), equals({Suits.hearts}));

    reds.add(Suits.diamonds);
    expect(reds.toSet(), equals({Suits.diamonds, Suits.hearts}));
    expect(reds.toSet(), equals({Suits.hearts, Suits.diamonds}));

    reds.remove(Suits.diamonds);
    expect(reds.toSet(), equals({Suits.hearts}));

    reds.remove(Suits.hearts);
    expect(reds.toSet(), isEmpty);
  });
}

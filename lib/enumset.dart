library enumset;

/// A bit field representing a set of enum instances. See Java's EnumSet.
/// 
/// This class works by assigning an increasing power of two to each instance 
/// of the enum, in the order it was declared, and saving it to [flags]. 
/// 
/// ```dart
/// enum Suit {spades, clubs, hearts, diamonds}
/// final EnumSet<Suit> reds = EnumSet(Suit.values)
/// print(reds);  // 0, because it's empty
/// print(reds.flags); 
/// // {Suit.spades: 1, Suit.clubs: 2, Suit.hearts: 4, Suit.diamonds: 8}
/// ```
/// 
/// This is done so that the entire collection can be represented in binary.
/// 
/// ```dart
/// reds.addAll(Suit.hearts, Suit.diamonds);
/// // addAll() adds the bits of each element together
/// // So, 4 + 8 = 12. In binary: 
/// //   0100
/// // + 1000
/// // -------
/// //   1100
/// print(reds);  // 1100 = 12
/// ```
/// 
/// Adding is equal to bitwise OR, and removing elements is bitwise XOR.
/// Checking if an element is in the set is done with bitwise AND.
/// 
/// ```dart
/// print(reds.contains(Suits.spades));  // false
/// //   1100
/// // & 0001
/// // ------
/// //   0000
/// 
/// print(reds.contains(Suits.hearts));  // true
/// //   1100
/// // & 0100
/// // ------
/// //   0100, which is not 0 (and is equal to 4 -- the value of Suit.hearts)
/// ```
/// 
/// You can also convert an EnumSet to a list of its values: 
/// 
/// ```dart
/// print(reds.toList());  // [Suit.hearts, Suit.diamonds]
/// ```
class EnumSet<T> {
  /// Maps instances of [T] to their power-of-two values.
  Map<T, int> flags = {};

  /// The bit field this set represents.
  int bits = 0;

  /// Creates an empty bit field for [values].
  EnumSet(List<T> values) : flags = {
    for (int index = 0; index < values.length; index++)
      values [index]: 1 << index,
  };

  /// Used for copying.
  EnumSet._(this.flags, this.bits);

  @override
  String toString() => "$T ${bits.toRadixString(2)}";

  @override
  bool operator ==(Object other) => other is EnumSet<T> 
    && flags.keys.every((key) => other.flags[key] == flags[key])
    && other.bits == bits;

  @override
  int get hashCode => bits.hashCode + flags.hashCode;

  /// Gets the binary value of the passed in value.
  /// 
  /// Since this class is optimized for enums, this will throw if you pass in a
  /// value that wasn't included when creating this set. This is because enums
  /// have a `.values` list that are guaranteed to contain all the elements of 
  /// the enum.
  int operator [](T value) => flags[value]!;

  /// Copies this set so any modifications made on one don't affect the other.
  EnumSet<T> copy() => EnumSet._(flags, bits);

  /// Adds all the given values to this set.
  void addAll(Iterable<T> values) => values.forEach(add);
    
  /// Adds the given value to this set.
  void add(T value) => bits |= this[value];

  /// Removes the given value from this set.
  void remove(T value) => bits &= ~this[value];

  /// Checks if the given value is contained within this set.
  bool contains(T value) => bits & this[value] != 0;

  /// Returns all the elements of this set.
  Set<T> toSet() => {
    for (final T value in flags.keys)
      if (contains(value)) value
  };
} 

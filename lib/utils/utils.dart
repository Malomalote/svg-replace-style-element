String svgRemoveStyleLabel(String input) {
  String transformsvg = input;
  if (input.contains('<style')) {
    int posInit = input.indexOf('<style');
    int posEnd = input.indexOf('</style>');
    String styleString = input
        .substring(posInit, posEnd + '</style>'.length)
        .replaceAllMapped(RegExp('<style.*'), (match) => '')
        .replaceAll('</style>', '');
    List<String> stylesRaw = styleString.split('.');
    List<Pair<String, String>> styles = [];
    for (var l in stylesRaw) {
      String first = l.split('{').first.trim();
      String second = l.split('{').last.split('}').first;
      styles.add(Pair(first, second));
    }
    for (var j in styles) {
      transformsvg =
          transformsvg.replaceAll('class="${j.first}"', 'style="${j.second}"');
    }
  }
  return transformsvg;
}

//from https://stackoverflow.com/questions/64282563/list-of-tuples-in-flutter-dart
class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  String toString() => 'Pair(a: $first, b: $second)';
}
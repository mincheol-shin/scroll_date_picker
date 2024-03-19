extension ListExtension on List {
  String get longestString {
    String longestText = '';
    this.forEach((element) {
      if ('$element'.length > longestText.length) {
        longestText = '$element'.padLeft(2, '0');
      }
    });
    return longestText;
  }
}

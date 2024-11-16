void main() {
  String text = 'Lorem ipsum is a dummy or placeholder text used in design.';
  print(text.truncate(20));
}

extension on String {
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}

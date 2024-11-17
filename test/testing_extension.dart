
import 'package:intl/intl.dart';

void main() {
 
  print('11z f - dld - 2024-11-16T19:44:55.357816'.formate());
}

extension on String {
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}


extension on String {
  String formate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (_) {
      return 'Invalid date';
    }
  }
}
// Input: '2024-11-16T19:44:55.357816'.formate()
// Output: November 16, 2024
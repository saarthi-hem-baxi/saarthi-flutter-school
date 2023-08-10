/// index starting from 0
String getAlphabetByIndex({required int index, bool? isUpperCase}) {
  index++;
  if (index <= 26) {
    return String.fromCharCode(index + 64);
  } else {
    int firstChar = ((index - 1) ~/ 26) + 64;
    int secondChar = ((index - 1) % 26) + 65;
    if (isUpperCase == true) {
      return String.fromCharCode(firstChar) + String.fromCharCode(secondChar).toUpperCase();
    } else {
      return String.fromCharCode(firstChar) + String.fromCharCode(secondChar).toLowerCase();
    }
  }
}

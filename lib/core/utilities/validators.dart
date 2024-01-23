bool minimumLengthValidator(String text, int len) {
  return text.length >= len;
}

bool isEmailValid(String inputemail) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
  RegExp regexp = RegExp(pattern.toString());
  return regexp.hasMatch(inputemail);
}

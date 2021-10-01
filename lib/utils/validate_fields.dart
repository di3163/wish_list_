bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern as String);
  //return (!regex.hasMatch(value)) ? false : true;
  return regex.hasMatch(value);
}

bool validatePhone(String value){
  Pattern pattern = r'^(?:[+0]9)?[0-9]{10}';

  RegExp regex = RegExp(pattern as String);
  //return (!regex.hasMatch(value)) ? false : true;
  return regex.hasMatch(value);
}
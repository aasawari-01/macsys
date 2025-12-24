class Validator{

  static String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email ID";
    } else {
      return '';
    }
  }

  static String validateAccountNo(String value) {
    String pattern = r'(^[a-zA-Z0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "No is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid No";
    } else {
      return '';
    }
  }

  static String validatePassword(String value) {

    // print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 4) {
      return "Please enter password";
    } else {
        return '';
    }
  }

  static String validateConfirmPassword(String value, String value2) {

    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    // print(value);
    if (value.isEmpty) {
      return 'Enter confirm password';
    } else if (value.length < 7) {
      return "You need at least 8 charecter";
    } else if (!regex.hasMatch(value)) {
        return 'Enter valid confirm password';
        // 'Password required \nAt least one upper case, \nAt least one lower case character, \nAt least one digit and \nAt least one Special character.\nEx.(Jan9ua@ry)';

    }else if(value != value2){
      return 'Password and Confirm Password does not match';
    }else {
        return '';
      }
  }

  static String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone Number required";
    } else if (value.length != 9) {
      return "Enter phone number";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return '';
  }

  static String validateName(String value) {
    String patttern = r'(^[a-zA-Z 0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter user name";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid user name";
    }
    return '';
  }
  static String validateJobDescription(String value) {
    String patttern = r'(^[a-zA-Z 0-9.,_-]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter job description";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid job description";
    }
    return '';
  }

  static String validateUniversity(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter your college/university name";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid college/university name";
    }
    return '';
  }

  static String validateSwiftCode(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter valid Swift Code";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid Swift Code";
    }
    return '';
  }

  static String validateReading(String value,title) {
    print("value  : $value");
    String patttern = r'(^[0-9].*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Please add $title";
    }  else if (!regExp.hasMatch(value)) {
      return "Please enter valid $title";
    }
    return '';
  }
  static String validateBlank(String value,title) {
    print("value  : $value");
    if (value.isEmpty) {
      return "Please add $title";
    }
    return '';
  }

  static String validateReason(String value) {
    String patttern = r'(^[a-zA-Z 0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Please enter reason";
    } else if (!regExp.hasMatch(value)) {
      return "Enter valid reason";
    }
    return '';
  }

  static String validateSetLimitsAmount(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty || value == '0') {
      return "Please enter limits amount";
    } else if (value.length >= 6) {
      return "You can set Max limits 999999";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid amount";
    }
    return '';
  }

  static String validateLowAmount(String value) {
    // print("value  : $value");
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.isEmpty || value == '0') {
      return "Please enter limits amount";
    } else if (value.length >= 4) {
      return "You can set Max limits 9999";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid amount";
    }
    return '';
  }

}
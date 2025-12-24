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

  static String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter Phone Number";
    } else if (value.length != 10) {
      return "Enter valid phone number";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return '';
  }

  static String otp(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter OTP";
    } else if (value.length != 1) {
      return "Enter valid OTP";
    } else if (!regExp.hasMatch(value)) {
      return "OTP must be digits";
    }
    return '';
  }


  static String validateName(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter Valid First Name";
    } else if (!regExp.hasMatch(value)) {
      return "Enter Valid First Name";
    }
    return '';
  }
  static String validateLName(String value) {

    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter Valid Last Name";
    } else if (!regExp.hasMatch(value)) {
      return "Enter Valid Last Name";
    }
    return '';
  }




}
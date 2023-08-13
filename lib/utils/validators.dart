
class Validators {

  /// REG EXP \\\
  static final RegExp regExpEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp regExpPw = RegExp(
      r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static final RegExp regexImage = RegExp(
      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
  static final RegExp regExpPhone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  static final RegExp regExpName = RegExp('[a-zA-Z]',);
  static final RegExp conditionEegExp = RegExp(
      r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final RegExp numberRegExp = RegExp(r'\d');
  static final RegExp langEnRegExp = RegExp('[a-zA-Z]');
  static final RegExp langEnArRegExp = RegExp('[a-zA-Zء-ي]');
  static final RegExp langArRegExp = RegExp('[ء-ي]');
  static final RegExp yearRegExp = RegExp(r'^(\d{4}$)');
  static final RegExp arabicRegExp = RegExp(
      "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");

  static String? validateName(String? v, { required String text}) {
    return !v!.contains(langEnArRegExp)
        ? 'برجاء ادخال ${text} بشكل صحيح'
        : null;
  }

  static String? validateNumber(String? v, { required String text}) {
    return !v!.contains(numberRegExp) ? 'برجاء ادخال ${text} بشكل صحيح' : null;
  }

  static String? validateEmail(String? v) {
    return !v!.contains(regExpEmail) ? 'برجاء ادخال بريد الكتروني صحيح' : null;
  }

  static String? validateYear(String? v) {
    return !v!.contains(yearRegExp) ? 'برجاء ادخال سنة تخرج صحيحة' : null;
  }

  static String? validateEmailAndPhone(String? v) {
    return !v!.contains(regExpEmail) && !v.contains(regExpPhone)
        ? 'Enter Email Or Phone Number'
        : null;
  }

  static String? validatePhone(String? v) {
    return !v!.contains(regExpPhone) ? 'برجاء ادخال رقم الهاتف بشكل صحيح' : null;
  }

  static String? validatePw(String? v) {
    return !v!.contains(regExpPw) ? 'برجاء ادخال كلمة السر بشكل صحيح' : null;
  }

}
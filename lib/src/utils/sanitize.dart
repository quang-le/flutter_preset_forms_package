class Sanitize {
  static String htmlChars(String str) {
    return str
        //.replaceAll(RegExp(r'&'), '&amp;')
        .replaceAll(RegExp(r'"'), '&quot;')
        .replaceAll(RegExp(r"'"), '&#x27;')
        .replaceAll(RegExp(r'<'), '&lt;')
        .replaceAll(RegExp(r'>'), '&gt;')
        .replaceAll(RegExp(r';'), '&semi;')
        .replaceAll(RegExp(r':'), '&colon;')
        //.replaceAll(RegExp(r'|'), '&verbar;')
        .replaceAll(RegExp(r'/'), '&sol;')
        .replaceAll(RegExp(r'\('), '&lpar;')
        .replaceAll(RegExp(r'\)'), '&rpar;')
        .replaceAll(RegExp(r'\['), '&lsqb;')
        .replaceAll(RegExp(r'\]'), '&rsqb;');
  }

  String htmlCharsDelete(String str) {
    return str
        .replaceAll(RegExp(r'&'), '')
        .replaceAll(RegExp(r'"'), '')
        .replaceAll(RegExp(r"'"), '')
        .replaceAll(RegExp(r'<'), '')
        .replaceAll(RegExp(r'>'), '')
        .replaceAll(RegExp(r';'), '')
        .replaceAll(RegExp(r':'), '')
        // vertical bar somehow creates errors
        //.replaceAll(RegExp(r'|'), '')
        .replaceAll(RegExp(r'/'), '')
        .replaceAll(RegExp(r'\('), '')
        .replaceAll(RegExp(r'\)'), '')
        .replaceAll(RegExp(r'\['), '')
        .replaceAll(RegExp(r'\]'), '');
  }
}

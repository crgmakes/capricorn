class CustomTrace {
  final StackTrace _trace;

  String method = '';
  String package = '';

  CustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, we just want the first line, which has the information we need */
    //print(this._trace.toString());
    //print(this._trace.toString().split("\n"));
    //print(this._trace.toString().split(RegExp(r'\s+')));
    var traceString = _trace.toString().split("\n")[3];
    var traceElements = traceString.split(RegExp(r'\s+'));
    method = traceElements[1];
    package = traceElements[2];
  }
}

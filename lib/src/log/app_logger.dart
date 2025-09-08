import 'app_log_printer.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static Logger getLogger() {
    return Logger(
      printer: AppLogPrinter(),
    );
  }
}

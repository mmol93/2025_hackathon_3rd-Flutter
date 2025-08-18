import 'package:timezone/standalone.dart' as tz;

class TimeUtil {
  DateTime getCurrentJapanTime() {
    final tokyo = tz.getLocation('Asia/Tokyo');
    return tz.TZDateTime.now(tokyo);
  }
}

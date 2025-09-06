import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionService {
  static Future<bool> requestNotificationPermission() async {
    try {
      PermissionStatus status = await Permission.notification.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        PermissionStatus result = await Permission.notification.request();

        if (result.isGranted) {
          return true;
        } else if (result.isPermanentlyDenied) {
          await _showSettingsDialog();
          return false;
        } else {
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        await _showSettingsDialog();
        return false;
      }

      return false;
    } catch (e) {
      print('Permission request error: $e');
      return false;
    }
  }

  static Future<PermissionStatus> getNotificationPermissionStatus() async {
    return await Permission.notification.status;
  }

  static Future<bool> hasNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<void> _showSettingsDialog() async {
    await openAppSettings();
  }
}

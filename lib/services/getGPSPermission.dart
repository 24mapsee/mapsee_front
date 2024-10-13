import 'package:permission_handler/permission_handler.dart';

Future<bool> getGPSPermission() async {
  var status = await Permission.location.status;
  if (status.isGranted || status.isLimited) {
    return true;
  } else {
    var request = await Permission.location.request();
    if (request.isGranted || request.isLimited) {
      return true;
    } else if (request.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  return false;
}

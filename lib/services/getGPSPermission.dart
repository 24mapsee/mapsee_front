import 'package:permission_handler/permission_handler.dart';

void getGPSPermission() async {
  var status = await Permission.location.status;
  if (status.isGranted && status.isLimited) {
    return;
  } else {
    var request = await Permission.location.request();
    if (request.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}

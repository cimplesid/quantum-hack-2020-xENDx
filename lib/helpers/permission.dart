import 'package:permission_handler/permission_handler.dart';

class PemissionHelper {
  PermissionStatus permissionStatus = PermissionStatus.undetermined;
  Permission permission = Permission.location;

  Future listenForPermissionStatus() async {
    final status = await permission.status;
    permissionStatus = status;
  }

  Future<void> requestPermission() async {
    if (permissionStatus != PermissionStatus.granted) {
      final status = await permission.request();
      permissionStatus = status;
    }
  }

  checkPermission() async {
    await listenForPermissionStatus();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

final mPermission = PemissionHelper();

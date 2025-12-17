import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling Android media file permissions
class PermissionService {
  /// Request permissions for reading media files on Android
  /// Returns true if all required permissions are granted
  static Future<bool> requestMediaPermissions() async {
    if (!Platform.isAndroid) {
      return true; // No permissions needed on non-Android platforms
    }

    final permissions = <Permission>[
      Permission.manageExternalStorage,
      Permission.mediaLibrary,
      Permission.ignoreBatteryOptimizations,
    ];

    final statuses = await permissions.request();

    // Check if all permissions are granted
    return statuses.values.every((status) => status.isGranted);
  }

  /// Request permission to manage all files on Android (API 30+)
  /// This is required for accessing files in all directories
  static Future<bool> requestManageAllFilesPermission() async {
    if (!Platform.isAndroid) {
      return true; // No permissions needed on non-Android platforms
    }

    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  /// Request permission to read external storage (fallback for API < 30)
  static Future<bool> requestReadExternalStoragePermission() async {
    if (!Platform.isAndroid) {
      return true; // No permissions needed on non-Android platforms
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Request all storage-related permissions
  /// This handles both modern (API 30+) and legacy (API < 30) permissions
  static Future<bool> requestAllStoragePermissions() async {
    if (!Platform.isAndroid) {
      return true; // No permissions needed on non-Android platforms
    }

    // First try to request media-specific permissions
    final mediaGranted = await requestMediaPermissions();

    // Then request manage all files permission (for accessing all storage)
    final manageAllGranted = await requestManageAllFilesPermission();

    // If manage all files is not available/granted, try legacy storage permission
    if (!manageAllGranted) {
      await requestReadExternalStoragePermission();
    }

    return mediaGranted && manageAllGranted;
  }

  /// Check if we have permission to read media files
  static Future<bool> hasMediaPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final permissions = <Permission>[
      Permission.manageExternalStorage,
      Permission.mediaLibrary,
      Permission.ignoreBatteryOptimizations,
    ];

    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  /// Check if we have permission to manage all files
  static Future<bool> hasManageAllFilesPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  /// Open app settings to allow user to grant permissions manually
  static Future<bool> openAppSettings() async {
    return openAppSettings();
  }

  /// Show permission denied dialog and optionally open settings
  static Future<void> showPermissionDeniedDialog(
    Function() onOpenSettings,
  ) async {
    // This can be called from the UI to show a dialog
    // Implementation depends on your UI framework
  }
}

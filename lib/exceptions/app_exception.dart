import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  const factory AppException.general(String message) = AppGeneralException;
  const factory AppException.permission(Permission permission) =
      PermissionFailure;
}

extension AppExceptionMessage on AppException {
  String message() {
    return when(
      general: (msg) => msg,
      permission: (permission) =>
          "Access to ${permission.toString()} wasn't allowed. Please, allot access to it.",
    );
  }
}

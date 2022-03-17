// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class InheritedCameras extends InheritedWidget {
//   const InheritedCameras({
//     Key? key,
//     required Widget child,
//     required this.cameras,
//   }) : super(key: key, child: child);

//   final List<CameraDescription> cameras;

//   static InheritedCameras of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<InheritedCameras>();
//   }

//   @override
//   bool updateShouldNotify(InheritedCameras oldWidget) {
//     return oldWidget.cameras.any((item) => cameras.contains(item));
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class InheritedCameras extends InheritedWidget {
  final List<CameraDescription> cameras;
  const InheritedCameras({
    Key? key,
    required this.child,
    required this.cameras,
  }) : super(key: key, child: child);

  final Widget child;

  static InheritedCameras? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedCameras>();
  }

  @override
  bool updateShouldNotify(InheritedCameras oldWidget) {
    return oldWidget.cameras != cameras;
  }
}

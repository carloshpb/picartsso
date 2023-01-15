import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'app.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //var sharedPreferences = await SharedPreferences.getInstance();

  // Obtain a list of the available cameras on the device.
  //final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  //final firstCamera = cameras.first;

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(
    const ProviderScope(
      // overrides: [
      //   //Insert object created in main inside the provider that was already created
      //   sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      // ],
      child: App(),
    ),
  );
}

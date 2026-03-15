import 'package:flutter/widgets.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/app.dart';

void main() {
  ServiceLocator.init();
  runApp(const SwfApp());
}

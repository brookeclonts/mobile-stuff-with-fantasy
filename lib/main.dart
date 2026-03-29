import 'package:flutter/widgets.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.init();
  await ServiceLocator.sessionStore.init();
  // Restore the API client token from the persisted session.
  if (ServiceLocator.sessionStore.isAuthenticated) {
    ServiceLocator.apiClient.setSessionToken(ServiceLocator.sessionStore.token);
  }
  await ServiceLocator.localBookRepository.init();
  runApp(const SwfApp());
}

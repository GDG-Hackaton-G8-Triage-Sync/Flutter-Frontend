import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'main_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await dotenv.load(fileName: '.env.$flavor');
  await mainCommon();
}

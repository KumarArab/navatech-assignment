import 'package:flutter/material.dart';
import 'package:navatech/presentation/screens/album_screen/album_screen.dart';
import 'package:navatech/presentation/screens/album_screen/album_screen_controller.dart';
import 'package:navatech/repositories/db/hive_manager.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveManager().init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  static final _navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get navigationContext => _navigatorKey.currentContext!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navatech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: _navigatorKey,
      home: ChangeNotifierProvider(create: (ctx) => AlbumScreenController(), child: const AlbumScreen()),
    );
  }
}

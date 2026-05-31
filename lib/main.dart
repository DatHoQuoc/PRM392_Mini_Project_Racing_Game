import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // Import màn hình Home vừa tách

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khóa cứng ứng dụng ở chế độ Landscape (màn hình ngang)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MiniRacingGameApp());
  });
}

class MiniRacingGameApp extends StatelessWidget {
  const MiniRacingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Racing Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6F001D),
      ),
      home: const GameHomeScreen(), // Gọi đến màn hình Home sạch sẽ
    );
  }
}
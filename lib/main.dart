import 'package:flutter/material.dart';
void main()=>runApp(const RuyamApp());
class RuyamApp extends StatelessWidget {
  const RuyamApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: const Color(0xFFD4AF37)),
      home: const GirisSayfasi(),
    );
  }
}
class GirisSayfasi extends StatelessWidget {
  const GirisSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Color(0xFFD4AF37)),
            const Text('RÜYAM EXCLUSIVE', style: TextStyle(fontSize: 28, color: Color(0xFFD4AF37))),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
              onPressed: (){}, 
              child: const Text('GİRİŞ YAP', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

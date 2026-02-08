import 'package:flutter/material.dart';

void main() {
  runApp(const RuyamKuaforApp());
}

class RuyamKuaforApp extends StatelessWidget {
  const RuyamKuaforApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink), // Kuaför temasına uygun pembe tonları
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rüyam Bayan Kuaförü'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Üst Kapak Görseli Alanı
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.pink[50],
            child: const Icon(Icons.content_cut, size: 100, color: Colors.pink),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hoş Geldiniz!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Güzelliğinize giden yolda profesyonel dokunuşlar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          const Divider(),
          // Hizmetler Listesi
          Expanded(
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.check), title: Text('Saç Kesimi & Model')),
                ListTile(leading: Icon(Icons.check), title: Text('Boya & Röfle')),
                ListTile(leading: Icon(Icons.check), title: Text('Gelin Saçı & Makyaj')),
              ],
            ),
          ),
          // Randevu Butonu
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.pink,
              ),
              onPressed: () {
                // Buraya ileride randevu alma fonksiyonu eklenecek
              },
              child: const Text('HEMEN RANDEVU AL', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

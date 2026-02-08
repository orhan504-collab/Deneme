import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase bağlantı ayarları
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'Sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );

  runApp(const RuyamApp());
}

class RuyamApp extends StatelessWidget {
  const RuyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rüyam Exclusive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const RandevuSayfasi(),
    );
  }
}

class RandevuSayfasi extends StatefulWidget {
  const RandevuSayfasi({super.key});

  @override
  State<RandevuSayfasi> createState() => _RandevuSayfasiState();
}

class _RandevuSayfasiState extends State<RandevuSayfasi> {
  final _adController = TextEditingController();
  final _telController = TextEditingController();
  String _secilenIslem = 'Fön';

  Future<void> randevuKaydet() async {
    if (_adController.text.isEmpty || _telController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    try {
      // DİKKAT: Tablo adını Supabase'deki "RuyamDB" ile eşitledik
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text,
        'Tel': _telController.text,
        'islem': _secilenIslem,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Randevunuz Başarıyla Alındı!'),
          backgroundColor: Colors.green,
        ),
      );
      _adController.clear();
      _telController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rüyam Exclusive Randevu'),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(25.0),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.content_cut, size: 50, color: Colors.pink),
                  const SizedBox(height: 20),
                  const Text(
                    'Hızlı Randevu Al',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _adController,
                    decoration: const InputDecoration(
                      labelText: 'Ad Soyad',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _telController,
                    decoration: const InputDecoration(
                      labelText: 'Telefon Numarası',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _secilenIslem,
                    decoration: const InputDecoration(
                      labelText: 'İşlem Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.auto_fix_high),
                    ),
                    onChanged: (yeni) => setState(() => _secilenIslem = yeni!),
                    items: <String>['Fön', 'Boya', 'Kesim', 'Makyaj', 'Manikür'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: randevuKaydet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Randevuyu Onayla',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

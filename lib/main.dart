import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // İşte senin gerçek anahtarınla güncellenmiş bağlantı:
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'Sb_publishable_fgGzVzBsmAYIqZ68T4fLag_vtP9HvZe', 
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
      // Supabase'deki tablo adın: RuyamDB
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text,
        'Tel': _telController.text,
        'islem': _secilenIslem,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Randevunuz Başarıyla Alındı! ✅'),
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
            padding: const EdgeInsets.all(25.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_available, size: 50, color: Colors.pink),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _adController,
                    decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _telController,
                    decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _secilenIslem,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    onChanged: (v) => setState(() => _secilenIslem = v!),
                    items: ['Fön', 'Boya', 'Kesim', 'Manikür'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: randevuKaydet,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Randevu Al', style: TextStyle(color: Colors.white)),
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

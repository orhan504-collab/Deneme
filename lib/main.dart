import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase bağlantısını başlat
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RandevuSayfasi(),
  ));
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
  bool _yukleniyor = false;

  Future<void> randevuAl() async {
    if (_telController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen telefon girin!')));
      return;
    }

    setState(() => _yukleniyor = true);

    try {
      // Sütun isimleri: Ad, Tel, Islem (Büyük/Küçük harf duyarlı!)
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text.isEmpty ? 'Müşteri' : _adController.text,
        'Tel': _telController.text,
        'Islem': _secilenIslem,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevunuz başarıyla alındı! ✅'), backgroundColor: Colors.green));
      _adController.clear();
      _telController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata oluştu: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Exclusive Randevu'), centerTitle: true),
      body: Center(
        child: Container(
          maxWidth: 500, // Web'de çok yayılmasın diye
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _adController,
                decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _telController,
                decoration: const InputDecoration(labelText: 'Telefon Numarası', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _secilenIslem,
                decoration: const InputDecoration(labelText: 'İşlem Seçin', border: OutlineInputBorder()),
                items: ['Fön', 'Boya', 'Kesim', 'Makyaj']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _secilenIslem = val!),
              ),
              const SizedBox(height: 25),
              _yukleniyor 
                ? const CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: randevuAl,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Randevu Al'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

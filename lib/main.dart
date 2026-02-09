import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final _ad = TextEditingController();
  final _tel = TextEditingController();
  String _secilen = 'Fön';

  Future<void> randevuAl() async {
    if (_tel.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Telefon boş olamaz!')));
      return;
    }
    try {
      // Sütun isimleri tam olarak veritabanındakilerle aynı olmalı
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _ad.text.isEmpty ? 'Müşteri' : _ad.text,
        'Tel': _tel.text,
        'Islem': _secilen,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevunuz Alındı! ✅')));
      _ad.clear(); _tel.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Exclusive'), centerTitle: true),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          maxWidth: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _ad, decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: _tel, decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _secilen,
                items: ['Fön', 'Boya', 'Kesim', 'Makyaj'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _secilen = v!),
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'İşlem'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(onPressed: randevuAl, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text('Randevu Al')),
            ],
          ),
        ),
      ),
    );
  }
}

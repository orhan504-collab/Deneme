import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );
  runApp(const MaterialApp(home: RandevuSayfasi(), debugShowCheckedModeBanner: false));
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

  // Veritabanındaki sütun adları: Ad, Tel, Islem
  Future<void> kaydet() async {
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _ad.text.isEmpty ? 'Müşteri' : _ad.text,
        'Tel': _tel.text,
        'Islem': _secilen,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevu Alındı! ✅')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüyam Exclusive'), backgroundColor: Colors.pink[100]),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _ad, decoration: const InputDecoration(labelText: 'Ad Soyad')),
            TextField(controller: _tel, decoration: const InputDecoration(labelText: 'Telefon')),
            DropdownButton<String>(
              value: _secilen,
              items: ['Fön', 'Boya', 'Kesim'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _secilen = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: kaydet, child: const Text('Randevu Al')),
          ],
        ),
      ),
    );
  }
}

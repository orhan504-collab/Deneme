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
    home: RuyamWeb(),
  ));
}

class RuyamWeb extends StatefulWidget {
  const RuyamWeb({super.key});
  @override
  State<RuyamWeb> createState() => _RuyamWebState();
}

class _RuyamWebState extends State<RuyamWeb> {
  // Varsayılan ayarlar (Veritabanı boşsa bunlar görünür)
  bool _adGoster = true; 
  bool _telGoster = true;
  List<String> _hizmetler = ['Fön', 'Boya', 'Kesim'];
  String? _secilen;
  final _ad = TextEditingController();
  final _tel = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ayarlariCek();
  }

  Future<void> _ayarlariCek() async {
    try {
      final res = await Supabase.instance.client.from('WebAyarlari').select();
      if (res.isNotEmpty) {
        setState(() {
          for (var item in res) {
            if (item['anahtar'] == 'ad_aktif') _adGoster = item['deger'] == 'true';
            if (item['anahtar'] == 'tel_aktif') _telGoster = item['deger'] == 'true';
            if (item['anahtar'] == 'servisler') {
              _hizmetler = (item['deger'] as String).split(',');
              if (_hizmetler.isNotEmpty) _secilen = _hizmetler.first;
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            maxWidth: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                const Text('RÜYAM BAYAN KUAFÖRÜ', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 20),
                if (_adGoster) TextField(controller: _ad, decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
                if (_adGoster) const SizedBox(height: 10),
                if (_telGoster) TextField(controller: _tel, decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder())),
                if (_telGoster) const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _secilen,
                  hint: const Text("Hizmet Seçiniz"),
                  items: _hizmetler.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _secilen = v),
                  decoration: const InputDecoration(labelText: 'İşlem', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await Supabase.instance.client.from('RuyamDB').insert({
                      'Ad': _adGoster ? _ad.text : 'İsimsiz',
                      'Tel': _telGoster ? _tel.text : 'No Yok',
                      'Islem': _secilen ?? 'Seçilmedi',
                    });
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevu Alındı! ✨')));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white, minSize: const Size(double.infinity, 50)),
                  child: const Text('RANDEVU AL'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

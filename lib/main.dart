import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );
  runApp(const MaterialApp(home: RuyamWebDinamik(), debugShowCheckedModeBanner: false));
}

class RuyamWebDinamik extends StatefulWidget {
  const RuyamWebDinamik({super.key});
  @override
  State<RuyamWebDinamik> createState() => _RuyamWebDinamikState();
}

class _RuyamWebDinamikState extends State<RuyamWebDinamik> {
  bool _adGoster = true;
  bool _telGoster = true;
  List<String> _hizmetler = ['Fön', 'Boya', 'Kesim'];
  String? _secilenHizmet;
  final _adCont = TextEditingController();
  final _telCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ayarlariCek();
  }

  // APK'dan yaptığınız ayarları çeker
  Future<void> _ayarlariCek() async {
    try {
      final veri = await Supabase.instance.client.from('WebAyarlari').select();
      for (var ayar in veri) {
        if (ayar['anahtar'] == 'ad_aktif') setState(() => _adGoster = ayar['deger'] == 'true');
        if (ayar['anahtar'] == 'tel_aktif') setState(() => _telGoster = ayar['deger'] == 'true');
        if (ayar['anahtar'] == 'servisler') {
          setState(() {
            _hizmetler = (ayar['deger'] as String).split(',');
            _secilenHizmet = _hizmetler.first;
          });
        }
      }
    } catch (e) {
      debugPrint("Ayar çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Center(
        child: Container(
          maxWidth: 400,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('RÜYAM BAYAN KUAFÖRÜ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink)),
              const SizedBox(height: 30),
              if (_adGoster) TextField(controller: _adCont, decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder())),
              if (_adGoster) const SizedBox(height: 15),
              if (_telGoster) TextField(controller: _telCont, decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder())),
              if (_telGoster) const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _secilenHizmet,
                items: _hizmetler.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _secilenHizmet = v),
                decoration: const InputDecoration(labelText: 'İşlem Seçin', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await Supabase.instance.client.from('RuyamDB').insert({
                    'Ad': _adGoster ? _adCont.text : 'İsimsiz',
                    'Tel': _telGoster ? _telCont.text : 'No Yok',
                    'Islem': _secilenHizmet,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Randevunuz Alındı! ✨')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, minimumSize: const Size(double.infinity, 50)),
                child: const Text('RANDEVU AL', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

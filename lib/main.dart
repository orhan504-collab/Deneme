import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase'i başlatıyoruz
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Rüyam Kuaför',
    home: RuyamWebSayfasi(),
  ));
}

class RuyamWebSayfasi extends StatefulWidget {
  const RuyamWebSayfasi({super.key});

  @override
  State<RuyamWebSayfasi> createState() => _RuyamWebSayfasiState();
}

class _RuyamWebSayfasiState extends State<RuyamWebSayfasi> {
  // Başlangıç değerleri
  bool _adGoster = true;
  bool _telGoster = true;
  List<String> _hizmetler = ['Fön', 'Boya', 'Kesim'];
  String? _secilenHizmet;
  
  final _adController = TextEditingController();
  final _telController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ayarlariGetir();
  }

  // Veritabanından yönetici ayarlarını çeker
  Future<void> _ayarlariGetir() async {
    try {
      final veri = await Supabase.instance.client.from('WebAyarlari').select();
      
      if (veri != null && veri.isNotEmpty) {
        setState(() {
          for (var ayar in veri) {
            if (ayar['anahtar'] == 'ad_aktif') _adGoster = ayar['deger'] == 'true';
            if (ayar['anahtar'] == 'tel_aktif') _telGoster = ayar['deger'] == 'true';
            if (ayar['anahtar'] == 'servisler') {
              _hizmetler = (ayar['deger'] as String).split(',');
              if (_hizmetler.isNotEmpty) _secilenHizmet = _hizmetler.first;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Ayar çekme hatası: $e');
    }
  }

  // Randevuyu kaydeder
  Future<void> _randevuAl() async {
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adGoster ? _adController.text : 'İsimsiz',
        'Tel': _telGoster ? _telController.text : 'No Yok',
        'Islem': _secilenHizmet ?? 'Belirsiz',
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Randevunuz başarıyla alındı! ✅'), backgroundColor: Colors.green),
        );
        _adController.clear();
        _telController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Hata oluştu: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Tatlı pembe arka plan
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 15, spreadRadius: 5)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('RÜYAM KUAFÖR', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink)),
              const SizedBox(height: 30),
              
              if (_adGoster) 
                TextField(
                  controller: _adController,
                  decoration: const InputDecoration(labelText: 'Adınız Soyadınız', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                ),
              if (_adGoster) const SizedBox(height: 15),

              if (_telGoster) 
                TextField(
                  controller: _telController,
                  decoration: const InputDecoration(labelText: 'Telefon Numaranız', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
                ),
              if (_telGoster) const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _secilenHizmet,
                decoration: const InputDecoration(labelText: 'İşlem Seçiniz', border: OutlineInputBorder(), prefixIcon: Icon(Icons.cut)),
                items: _hizmetler.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _secilenHizmet = v),
              ),
              
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _randevuAl,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                  child: const Text('RANDEVU OLUŞTUR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const RuyamExclusiveApp());
}

// --- GLOBAL AYARLAR VE VERİ YAPISI ---
class ExclusiveAyarlar {
  static bool isimGerekli = true;
  static bool telGerekli = true;
  static bool islemGerekli = true;
  static const Color altin = Color(0xFFD4AF37);
  static const Color koyuArkaPlan = Color(0xFF0A0A0A);
}

class Randevu {
  final String id;
  final String adSoyad;
  final String telefon;
  final String islem;

  Randevu({required this.id, required this.adSoyad, required this.telefon, required this.islem});
}

List<Randevu> tumRandevular = [];

// --- UYGULAMA BAŞLANGICI ---
class RuyamExclusiveApp extends StatelessWidget {
  const RuyamExclusiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rüyam Exclusive',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: ExclusiveAyarlar.altin,
        scaffoldBackgroundColor: ExclusiveAyarlar.koyuArkaPlan,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: ExclusiveAyarlar.altin, fontSize: 20, letterSpacing: 2),
        ),
      ),
      home: const GirisEkrani(),
    );
  }
}

// --- GİRİŞ EKRANI (Web ve Mobil Uyumlu) ---
class GirisEkrani extends StatelessWidget {
  const GirisEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF222222), Colors.black],
            radius: 1.2,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, size: 80, color: ExclusiveAyarlar.altin),
                const SizedBox(height: 20),
                const Text(
                  'RÜYAM',
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w200, letterSpacing: 10, color: ExclusiveAyarlar.altin),
                ),
                const Text(
                  'EXCLUSIVE BEAUTY SALON',
                  style: TextStyle(fontSize: 12, letterSpacing: 3, color: Colors.white54),
                ),
                const SizedBox(height: 60),
                _girisButonu(context, 'MÜŞTERİ RANDEVU SİSTEMİ', const MusteriPaneli(), true),
                const SizedBox(height: 20),
                _girisButonu(context, 'İŞLETME YÖNETİM PANELİ', const IsletmePaneli(), false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _girisButonu(BuildContext context, String metin, Widget sayfa, bool dolu) {
    return SizedBox(
      width: 300,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: dolu ? ExclusiveAyarlar.altin : Colors.transparent,
          foregroundColor: dolu ? Colors.black : ExclusiveAyarlar.altin,
          side: const BorderSide(color: ExclusiveAyarlar.altin, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => sayfa)),
        child: Text(metin, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ),
    );
  }
}

// --- MÜŞTERİ RANDEVU FORMU ---
class MusteriPaneli extends StatefulWidget {
  const MusteriPaneli({super.key});
  @override
  State<MusteriPaneli> createState() => _MusteriPaneliState();
}

class _MusteriPaneliState extends State<MusteriPaneli> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _islemController = TextEditingController();

  void _randevuKaydet() {
    setState(() {
      tumRandevular.add(Randevu(
        id: DateTime.now().toString(),
        adSoyad: _adController.text,
        telefon: _telController.text,
        islem: _islemController.text,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Randevunuz başarıyla iletildi.'), backgroundColor: ExclusiveAyarlar.altin),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RANDEVU AL')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            if (ExclusiveAyarlar.isimGerekli) _inputAlani(_adController, 'Ad Soyad', Icons.person),
            if (ExclusiveAyarlar.telGerekli) _inputAlani(_telController, 'Telefon', Icons.phone),
            if (ExclusiveAyarlar.islemGerekli) _inputAlani(_islemController, 'Yapılacak İşlem', Icons.cut),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ExclusiveAyarlar.altin,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: _randevuKaydet,
              child: const Text('RANDEVUYU ONAYLA', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputAlani(TextEditingController controller, String etiket, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: etiket,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(ikon, color: ExclusiveAyarlar.altin),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ExclusiveAyarlar.altin)),
        ),
      ),
    );
  }
}

// --- İŞLETME YÖNETİM PANELİ ---
class IsletmePaneli extends StatefulWidget {
  const IsletmePaneli({super.key});
  @override
  State<IsletmePaneli> createState() => _IsletmePaneliState();
}

class _IsletmePaneliState extends State<IsletmePaneli> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('YÖNETİM PANELİ'),
          bottom: const TabBar(
            indicatorColor: ExclusiveAyarlar.altin,
            tabs: [Tab(text: 'RANDEVULAR'), Tab(text: 'FORM AYARLARI')],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Sekme: Randevu Listesi
            tumRandevular.isEmpty
                ? const Center(child: Text('Henüz bir randevu bulunmuyor.'))
                : ListView.builder(
                    itemCount: tumRandevular.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color(0xFF1A1A1A),
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: ListTile(
                          title: Text(tumRandevular[index].adSoyad, style: const TextStyle(color: ExclusiveAyarlar.altin)),
                          subtitle: Text("İşlem: ${tumRandevular[index].islem}\nTel: ${tumRandevular[index].telefon}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => setState(() => tumRandevular.removeAt(index)),
                          ),
                        ),
                      );
                    },
                  ),
            // 2. Sekme: Form Ayarları
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _ayarSwitch("Müşteri İsmi İstensin", ExclusiveAyarlar.isimGerekli, (v) => setState(() => ExclusiveAyarlar.isimGerekli = v)),
                  _ayarSwitch("Telefon Numarası İstensin", ExclusiveAyarlar.telGerekli, (v) => setState(() => ExclusiveAyarlar.telGerekli = v)),
                  _ayarSwitch("İşlem Detayı İstensin", ExclusiveAyarlar.islemGerekli, (v) => setState(() => ExclusiveAyarlar.islemGerekli = v)),
                  const Spacer(),
                  const Text("Buradaki değişiklikler müşteri formuna anında yansır.", style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ayarSwitch(String baslik, bool deger, Function(bool) degisim) {
    return SwitchListTile(
      title: Text(baslik),
      activeColor: ExclusiveAyarlar.altin,
      value: deger,
      onChanged: degisim,
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const RuyamExclusiveApp());
}

// --- DINAMIK AYARLAR VE VERILER ---
class ExclusiveSettings {
  static bool isimSor = true;
  static bool telSor = true;
  static bool islemSor = true;
  static Color altinSarisi = const Color(0xFFD4AF37);
}

class Randevu {
  final String isim;
  final String tel;
  final String islem;
  Randevu({required this.isim, required this.tel, required this.islem});
}

List<Randevu> randevular = [];

class RuyamExclusiveApp extends StatelessWidget {
  const RuyamExclusiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: ExclusiveSettings.altinSarisi,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        fontFamily: 'Georgia',
      ),
      home: const GirisSayfasi(),
    );
  }
}

// --- ANA GIRIS SAYFASI ---
class GirisSayfasi extends StatelessWidget {
  const GirisSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Color(0xFFD4AF37), width: 2)),
          gradient: RadialGradient(colors: [Color(0xFF222222), Colors.black], radius: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 80, color: ExclusiveSettings.altinSarisi),
              const SizedBox(height: 20),
              Text('RÜYAM', style: TextStyle(fontSize: 48, letterSpacing: 8, color: ExclusiveSettings.altinSarisi, fontWeight: FontWeight.w200)),
              const Text('EXCLUSIVE SALON', style: TextStyle(fontSize: 14, letterSpacing: 4, color: Colors.white54)),
              const SizedBox(height: 60),
              _anaButon(context, 'MÜŞTERİ GİRİŞİ', const MusteriEkrani(), true),
              const SizedBox(height: 20),
              _anaButon(context, 'İŞLETME PANELİ', const IsletmeEkrani(), false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anaButon(BuildContext context, String metin, Widget sayfa, bool dolu) {
    return SizedBox(
      width: 280,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: dolu ? ExclusiveSettings.altinSarisi : Colors.transparent,
          side: BorderSide(color: ExclusiveSettings.altinSarisi),
          foregroundColor: dolu ? Colors.black : ExclusiveSettings.altinSarisi,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => sayfa)),
        child: Text(metin, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
    );
  }
}

// --- MÜŞTERİ EKRANI ---
class MusteriEkrani extends StatefulWidget {
  const MusteriEkrani({super.key});
  @override
  State<MusteriEkrani> createState() => _MusteriEkraniState();
}

class _MusteriEkraniState extends State<MusteriEkrani> {
  final TextEditingController _ad = TextEditingController();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _islem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VIP RANDEVU FORMU')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            if (ExclusiveSettings.isimSor) _ozelInput(_ad, 'İsim Soyisim', Icons.person),
            if (ExclusiveSettings.telSor) _ozelInput(_tel, 'Telefon Numarası', Icons.phone),
            if (ExclusiveSettings.islemSor) _ozelInput(_islem, 'İstenen İşlem', Icons.content_cut),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ExclusiveSettings.altinSarisi, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                setState(() => randevular.add(Randevu(isim: _ad.text, tel: _tel.text, islem: _islem.text)));
                Navigator.pop(context);
              },
              child: const Text('RANDEVU TALEBİNİ GÖNDER'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ozelInput(TextEditingController c, String l, IconData i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(controller: c, decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: ExclusiveSettings.altinSarisi), border: const OutlineInputBorder())),
    );
  }
}

// --- İŞLETME EKRANI ---
class IsletmeEkrani extends StatefulWidget {
  const IsletmeEkrani({super.key});
  @override
  State<IsletmeEkrani> createState() => _IsletmeEkraniState();
}

class _IsletmeEkraniState extends State<IsletmeEkrani> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADMIN PANEL'),
          bottom: TabBar(indicatorColor: ExclusiveSettings.altinSarisi, tabs: const [Tab(text: 'RANDEVULAR'), Tab(text: 'AYARLAR')]),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: randevular.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(randevular[i].isim, style: TextStyle(color: ExclusiveSettings.altinSarisi)),
                subtitle: Text("İşlem: ${randevular[i].islem}\nTel: ${randevular[i].tel}"),
                trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => randevular.removeAt(i))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ayarSwitch("İsim Alanı", ExclusiveSettings.isimSor, (v) => setState(() => ExclusiveSettings.isimSor = v)),
                  _ayarSwitch("Telefon Alanı", ExclusiveSettings.telSor, (v) => setState(() => ExclusiveSettings.telSor = v)),
                  _ayarSwitch("İşlem Alanı", ExclusiveSettings.islemSor, (v) => setState(() => ExclusiveSettings.islemSor = v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ayarSwitch(String t, bool v, Function(bool) c) {
    return SwitchListTile(title: Text(t), value: v, activeColor: ExclusiveSettings.altinSarisi, onChanged: c);
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const RuyamKuaforApp());
} class UygulamaAyarlari {
  static bool isimIstensin = true;
  static bool telIstensin = true;
  static bool islemIstensin = false;
}
class Randevu {
  final String ad;
  final String tel;
  final String islem;
  Randevu({required this.ad, required this.tel, required this.islem});
}
List<Randevu> randevuListesi = [];
class RuyamKuaforApp extends StatelessWidget {
  const RuyamKuaforApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const GirisSayfasi(),
    );
  }
}
// --- GİRİŞ SAYFASI ---
class GirisSayfasi extends StatelessWidget {
  const GirisSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.brush, size: 70, color: Colors.pink),
            const Text('Rüyam Kuaför', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriEkrani())),
              child: const Text('Müşteri Girişi'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IsletmeEkrani())),
              child: const Text('İşletme Girişi'),
            ),
          ],
        ),
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
      appBar: AppBar(title: const Text('Randevu Formu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (UygulamaAyarlari.isimIstensin) TextField(controller: _ad, decoration: const InputDecoration(labelText: 'Ad Soyad')),
            if (UygulamaAyarlari.telIstensin) TextField(controller: _tel, decoration: const InputDecoration(labelText: 'Telefon'), keyboardType: TextInputType.phone),
            if (UygulamaAyarlari.islemIstensin) TextField(controller: _islem, decoration: const InputDecoration(labelText: 'İşlem Seçimi (Fön, Boya vb.)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  randevuListesi.add(Randevu(ad: _ad.text, tel: _tel.text, islem: _islem.text));
                });
                Navigator.pop(context);
              },
              child: const Text('Randevuyu Kaydet'),
            ),
          ],
        ),
      ),
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
          title: const Text('Yönetim Paneli'),
          bottom: const TabBar(tabs: [Tab(text: 'Randevular'), Tab(text: 'Soru Ayarları')]),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: randevuListesi.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(randevuListesi[i].ad),
                subtitle: Text("İşlem: ${randevuListesi[i].islem}"),
                trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => randevuListesi.removeAt(i))),
              ),
            ),
            Column(
              children: [
                SwitchListTile(title: const Text("İsim Sorulsun"), value: UygulamaAyarlari.isimIstensin, onChanged: (v) => setState(() => UygulamaAyarlari.isimIstensin = v)),
                SwitchListTile(title: const Text("Telefon Sorulsun"), value: UygulamaAyarlari.telIstensin, onChanged: (v) => setState(() => UygulamaAyarlari.telIstensin = v)),
                SwitchListTile(title: const Text("İşlem Sorulsun"), value: UygulamaAyarlari.islemIstensin, onChanged: (v) => setState(() => UygulamaAyarlari.islemIstensin = v)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

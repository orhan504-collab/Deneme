import 'package:flutter/material.dart';

void main() {
  runApp(const RuyamKuaforApp());
}

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

// --- GLOBAL AYARLAR VE VERİLER ---
// İşletmenin seçtiği zorunlu alanlar
bool isimGerekli mi = true;
bool telGerekli mi = true;
bool islemGerekli mi = false;

class Randevu {
  final String id;
  final String adSoyad;
  final String telefon;
  final String islem;
  Randevu({required this.id, required this.adSoyad, required this.telefon, required this.islem});
}

List<Randevu> tumRandevular = [];

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
            const Icon(Icons.auto_awesome, size: 80, color: Colors.pink),
            const Text('Rüyam Kuaför', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(250, 50)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MusteriEkrani())),
              child: const Text('Müşteri Girişi'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(250, 50)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IsletmeEkrani())),
              child: const Text('İşletme Girişi'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MÜŞTERİ EKRANI (Dinamik Form) ---
class MusteriEkrani extends StatefulWidget {
  const MusteriEkrani({super.key});
  @override
  State<MusteriEkrani> createState() => _MusteriEkraniState();
}

class _MusteriEkraniState extends State<MusteriEkrani> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _islemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Randevu Al')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (isimGerekli mi) TextField(controller: _adController, decoration: const InputDecoration(labelText: 'Ad Soyad')),
            if (telGerekli mi) TextField(controller: _telController, decoration: const InputDecoration(labelText: 'Telefon'), keyboardType: TextInputType.phone),
            if (islemGerekli mi) TextField(controller: _islemController, decoration: const InputDecoration(labelText: 'Yapılacak İşlem (Boya, Kesim vb.)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tumRandevular.add(Randevu(
                    id: DateTime.now().toString(),
                    adSoyad: isimGerekli mi ? _adController.text : "Belirtilmedi",
                    telefon: telGerekli mi ? _telController.text : "Belirtilmedi",
                    islem: islemGerekli mi ? _islemController.text : "Belirtilmedi",
                  ));
                });
                Navigator.pop(context);
              }, 
              child: const Text('Randevuyu Onayla')
            ),
          ],
        ),
      ),
    );
  }
}

// --- İŞLETME EKRANI (Yönetim Paneli) ---
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
          title: const Text('İşletme Paneli'),
          bottom: const TabBar(tabs: [Tab(text: 'Randevular'), Tab(text: 'Form Ayarları')]),
        ),
        body: TabBarView(
          children: [
            // 1. Sekme: Gelen Randevular
            ListView.builder(
              itemCount: tumRandevular.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(tumRandevular[index].adSoyad),
                  subtitle: Text("İşlem: ${tumRandevular[index].islem}\nTel: ${tumRandevular[index].telefon}"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => tumRandevular.removeAt(index))),
                ),
              ),
            ),
            // 2. Sekme: Form Ayarları (İşletme buradan seçer)
            Column(
              children: [
                CheckboxListTile(title: const Text("Müşteri İsmi Sorulsun mu?"), value: isimGerekli mi, onChanged: (v) => setState(() => isimGerekli mi = v!)),
                CheckboxListTile(title: const Text("Telefon Sorulsun mu?"), value: telGerekli mi, onChanged: (v) => setState(() => telGerekli mi = v!)),
                CheckboxListTile(title: const Text("Yapılacak İşlem Sorulsun mu?"), value: islemGerekli mi, onChanged: (v) => setState(() => islemGerekli mi = v!)),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Buradan yaptığınız seçimler anında Müşteri Giriş ekranına yansır.", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 'Gizliliğe İzin Ver' diyerek geçtiğin o güçlü anahtar burada:
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_secret_WJofh5X8mh4yKczR3ysluw_QGvHZ05X',
  );

  runApp(const RuyamApp());
}

class RuyamApp extends StatelessWidget {
  const RuyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rüyam Exclusive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const RandevuSayfasi(),
    );
  }
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

  Future<void> randevuKaydet() async {
    if (_adController.text.isEmpty || _telController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    try {
      // Veritabanına yazma işlemi
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _adController.text,
        'Tel': _telController.text,
        'islem': _secilenIslem,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Randevunuz Başarıyla Alındı! ✅'),
          backgroundColor: Colors.green,
        ),
      );
      _adController.clear();
      _telController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rüyam Exclusive'),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_fix_high, size: 50, color: Colors.pink),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _adController,
                          decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _telController,
                          decoration: const InputDecoration(labelText: 'Telefon', border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _secilenIslem,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'İşlem'),
                          onChanged: (v) => setState(() => _secilenIslem = v!),
                          items: ['Fön', 'Boya', 'Kesim', 'Makyaj'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: randevuKaydet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Randevu Al', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Yönetici Paneli Butonu
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPaneli()));
                  },
                  icon: const Icon(Icons.admin_panel_settings, color: Colors.grey),
                  label: const Text('Randevuları Görüntüle', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// YENİ: YÖNETİCİ PANELİ SAYFASI
class AdminPaneli extends StatelessWidget {
  const AdminPaneli({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gelen Randevular'), backgroundColor: Colors.pink.shade100),
      body: StreamBuilder(
        stream: Supabase.instance.client.from('RuyamDB').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz randevu yok."));
          }
          
          final randevular = snapshot.data!;
          return ListView.builder(
            itemCount: randevular.length,
            itemBuilder: (context, index) {
              final veri = randevular[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.person, color: Colors.white)),
                  title: Text(veri['Ad'] ?? 'İsimsiz'),
                  subtitle: Text("${veri['islem']} - ${veri['Tel']}"),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

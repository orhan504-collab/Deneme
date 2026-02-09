import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cyhrdhttgtdbgwlbtbnw.supabase.co',
    anonKey: 'sb_publishable_LIOI2vJC5XPa0Jxd1VXEEg_lxkuJWRh',
  );
  runApp(const MaterialApp(home: RuyamWebPage(), debugShowCheckedModeBanner: false));
}

class RuyamWebPage extends StatefulWidget {
  const RuyamWebPage({super.key});
  @override
  State<RuyamWebPage> createState() => _RuyamWebPageState();
}

class _RuyamWebPageState extends State<RuyamWebPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _ad = TextEditingController();
  final _tel = TextEditingController();
  String _secilen = 'Fön';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  Future<void> randevuKaydet() async {
    if (_tel.text.isEmpty) return;
    try {
      await Supabase.instance.client.from('RuyamDB').insert({
        'Ad': _ad.text.isEmpty ? 'Müşteri' : _ad.text,
        'Tel': _tel.text,
        'Islem': _secilen,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Randevunuz Alındı! Işıltınızla bekliyoruz... ✨'), backgroundColor: Colors.pinkAccent),
      );
      _ad.clear(); _tel.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8), // Çok hafif pudra pembesi
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Üst Başlık ve Animasyon
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFFC1CC), Color(0xFFFF92A9)]),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.content_cut, color: Colors.white, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'RÜYAM BAYAN KUAFÖRÜ',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                    ),
                    Text('Güzelliğinize Güzellik Katın', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
            ),
            
            // Randevu Formu
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Text('Hemen Randevu Alın', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.pink)),
                    const SizedBox(height: 20),
                    TextField(controller: _ad, decoration: const InputDecoration(labelText: 'Ad Soyad', prefixIcon: Icon(Icons.person))),
                    const SizedBox(height: 15),
                    TextField(controller: _tel, decoration: const InputDecoration(labelText: 'Telefon', prefixIcon: Icon(Icons.phone))),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _secilen,
                      items: ['Fön', 'Boya', 'Kesim', 'Makyaj', 'Tırnak'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _secilen = v!),
                      decoration: const InputDecoration(labelText: 'Hizmet Seçimi'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: randevuKaydet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('PARILDAMAYA BAŞLAYIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

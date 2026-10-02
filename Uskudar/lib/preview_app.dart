import 'package:flutter/material.dart';

const _navy = Color(0xFF0B4169);
const _paleBlue = Color(0xFFEAF3F9);

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Üsküdar Belediyesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _navy),
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: _navy,
          centerTitle: false,
        ),
      ),
      home: const _PreviewHome(),
    );
  }
}

class _PreviewHome extends StatefulWidget {
  const _PreviewHome();

  @override
  State<_PreviewHome> createState() => _PreviewHomeState();
}

class _PreviewHomeState extends State<_PreviewHome> {
  int selectedTab = 0;

  void _notAvailable(String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$service, bağlantılar hazır olduğunda kullanılabilecek.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Üsküdar Belediyesi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            if (selectedTab == 0) ...[
              _header(),
              const SizedBox(height: 20),
              _demoNotice(),
              const SizedBox(height: 28),
              _sectionTitle('Belediye hizmetleri'),
              const SizedBox(height: 12),
              _serviceGrid(),
              const SizedBox(height: 26),
              _sectionTitle('Üsküdar’dan haberler'),
              const SizedBox(height: 12),
              _newsCard(),
            ] else if (selectedTab == 1) ...[
              _sectionTitle('İşlemler'),
              const SizedBox(height: 14),
              _demoNotice(),
              const SizedBox(height: 16),
              _serviceRow(Icons.receipt_long_outlined, 'Borç sorgulama'),
              _serviceRow(Icons.credit_card_outlined, 'Ödeme işlemleri'),
              _serviceRow(Icons.description_outlined, 'Başvuru takibi'),
              _serviceRow(Icons.history_outlined, 'İşlem geçmişi'),
            ] else ...[
              _sectionTitle('Hesabım'),
              const SizedBox(height: 14),
              _demoNotice(),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Üsküdar Belediyesi',
                          style: TextStyle(
                              color: _navy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text('Çağrı merkezi: 444 0 875'),
                      SizedBox(height: 6),
                      Text('superhizmet@uskudar.bel.tr'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) => setState(() => selectedTab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.apps_outlined), label: 'İşlemler'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Hesabım'),
        ],
      ),
    );
  }

  Widget _header() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/icons/ic_logo.png', height: 72, fit: BoxFit.contain),
            const SizedBox(height: 18),
            const Text(
              'Üsküdar cebinizde',
              style: TextStyle(
                  fontSize: 25, color: _navy, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text('Belediye hizmetlerine tek yerden erişin.'),
          ],
        ),
      );

  Widget _demoNotice() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _paleBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBDD5E5)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: _navy),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Demo önizleme',
                      style: TextStyle(
                          color: _navy, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('İşlemler, API bağlantıları kurulduğunda aktif olacak.'),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
            fontSize: 20, color: _navy, fontWeight: FontWeight.w700),
      );

  Widget _serviceGrid() => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.35,
        children: [
          _serviceTile(Icons.receipt_long_outlined, 'Borç sorgulama'),
          _serviceTile(Icons.credit_card_outlined, 'Ödemeler'),
          _serviceTile(Icons.description_outlined, 'Başvurular'),
          _serviceTile(Icons.campaign_outlined, 'Duyurular'),
        ],
      );

  Widget _serviceTile(IconData icon, String title) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _notAvailable(title),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: _navy, size: 32),
                Text(title,
                    style: const TextStyle(
                        color: _navy, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );

  Widget _serviceRow(IconData icon, String title) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(icon, color: _navy),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _notAvailable(title),
        ),
      );

  Widget _newsCard() => const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications_none, color: _navy),
              SizedBox(height: 12),
              Text('Duyurular yakında burada',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              SizedBox(height: 5),
              Text('Güncel içerikler bağlantılar açıldığında görüntülenecek.'),
            ],
          ),
        ),
      );
}

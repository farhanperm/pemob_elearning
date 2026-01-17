import 'package:flutter/material.dart';
import '../service/local_storage_service.dart';
import '../service/cloud_storage_service.dart';
import 'home_page.dart';

class StorageSelectorPage extends StatelessWidget {
  const StorageSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Storage')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Local Storage'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      storageService: LocalStorageService(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Cloud Storage (Firestore)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      storageService: CloudStorageService(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
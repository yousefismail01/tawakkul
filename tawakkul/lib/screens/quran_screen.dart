import 'package:flutter/material.dart';
import '../services/quran_service.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: QuranService.getVerses()
          .map(
            (verse) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  verse,
                  style: const TextStyle(fontSize: 24, fontFamily: 'Poppins'),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

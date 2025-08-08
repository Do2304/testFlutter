import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Ex2_SMS extends StatelessWidget {
  const Ex2_SMS({super.key});

  void launchURL() async {
    final Uri url = Uri.parse(
      'sms:0326067968?body=Hello Luli Manucians!♥️♥️♥️',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: launchURL,
          child: const Text('Show Flutter homepage'),
        ),
      ),
    );
  }
}

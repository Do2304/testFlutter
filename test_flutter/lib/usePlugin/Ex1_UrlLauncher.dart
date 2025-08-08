import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Ex1_UrlLauncher extends StatelessWidget {
  const Ex1_UrlLauncher({super.key});

  void launchURL() async {
    final Uri url = Uri.parse('https://www.facebook.com/thaibinhdo198');
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

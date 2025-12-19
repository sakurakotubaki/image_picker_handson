import 'package:flutter/material.dart';
import 'package:image_picker_handson/iamge_select_screen.dart';
import 'package:image_picker_handson/l10n/app_localizations.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.startScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(l10n.helloWorldOn(DateTime.now()),
            textAlign: .center,),
            ElevatedButton(
              onPressed: () {
                Navigator.of( context).push(
                  MaterialPageRoute(
                    builder: (context) => const IamgeSelectScreen(),
                  ),
                );
              },
              child: Text(l10n.start),
            ),
          ],
        ),
      ),
    );
  }
}
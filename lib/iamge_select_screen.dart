import 'package:flutter/material.dart';
import 'package:image_picker_handson/l10n/app_localizations.dart';

class IamgeSelectScreen extends StatefulWidget {
  const IamgeSelectScreen({super.key});

  @override
  State<IamgeSelectScreen> createState() => _IamgeSelectScreenState();
}

class _IamgeSelectScreenState extends State<IamgeSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreentTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ElevatedButton(onPressed: () {}, child: Text(l10n.imageSelect),),
            ElevatedButton(onPressed: () {}, child: Text(l10n.imageEdit),)
          ],
        ),
      ),
    );
  }
}
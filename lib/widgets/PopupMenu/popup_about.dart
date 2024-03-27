import 'package:flutter/material.dart';
import 'package:mypod/utils/app_constants.dart';

class PopupAbout extends StatelessWidget {
  const PopupAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('À propos de MyPod'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Image.asset(
              AppConstants.imageLogo,
              height: 160,
              width: 400,
            ),
            const Text('MyPod'),
            const Text('Version: 0.5'),
            const Text('Développé par: AGDM - L3 Rouen'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CustomHelper {

  dialogue(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Votre addresse mail et/ou votre mot de passe a été mal saisie"),
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("OK")
            ),
          ],
        );
      },
    );
  }

}
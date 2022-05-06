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

  leadingCustomAppBar() {
    return (
        ClipOval(
            child: SizedBox.fromSize(
                size: const Size.fromHeight(80),
                child: Image.network('https://pbs.twimg.com/profile_images/3141672525/42d0f32a6b76790e8d6f1ad6fcd30dbe_400x400.png', fit: BoxFit.cover),
            ),
        )
    );
  }

}
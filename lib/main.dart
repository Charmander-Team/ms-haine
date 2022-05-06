import 'package:flutter/foundation.dart';
import 'package:ms_haine/Fonctions/FirestoreHelper.dart';
import 'package:ms_haine/View/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'library/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyADNStgpkgQwjo35SiauoyImR9lMjw9Kf0",
          projectId: "ms-haine",
          storageBucket: "ms-haine.appspot.com",
          messagingSenderId: "351124660862",
          appId: "1:351124660862:web:527da7095abb736ec22e2f"
        ));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MS Haine',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: const MyHomePage(title: 'MS Haine'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Variables
  String mail = "";
  String password = "";
  String prenom ="";
  String nom = "";
  List<bool> selections = [true,false];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromHeight(80),
            child: Image.network('https://pbs.twimg.com/profile_images/3141672525/42d0f32a6b76790e8d6f1ad6fcd30dbe_400x400.png', fit: BoxFit.cover),
          ),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: bodyPage(),
        )
      ),
    );



  }

  Widget bodyPage(){
    return  Column(
        children : [
          ToggleButtons(
              children: const  [
                Text("Inscription"),
                Text("Connexion")
              ],
              isSelected: selections,
              selectedColor: Colors.orange,
              borderRadius: BorderRadius.circular(10),
              disabledColor: Colors.white,
              onPressed: (int selected){
                setState(() {
                  selections[selected] = true;
                  if(selected == 0){
                    selections[1] = false;
                  } else {
                    selections[0] = false;
                  }
                });
              },
          ),

          const SizedBox(height : 40),

    //Prénom
          (selections[0])?TextField(
              decoration : InputDecoration(
                  hintText:"Entrer votre prénom",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  )
              ),
              onChanged :(texte){
                setState((){
                  prenom = texte;
                });
              }
          ):Container(),

          const SizedBox(height : 40),

    // Nom
          (selections[0])?TextField(
              decoration : InputDecoration(
                  hintText:"Entrer votre nom",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  )
              ),
              onChanged :(texte){
                setState((){
                  nom = texte;
                });
              }
          ):Container(),

          const SizedBox(height : 40),

    // Email
          TextField(
              decoration : InputDecoration(
                  hintText:"Entrer votre adresse mail",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  )
              ),
              onChanged :(texte){
                setState((){
                  mail = texte;
                });
              }
          ),

          const SizedBox(height : 40),

    // Password
          TextField(
              obscureText : true,
              decoration : InputDecoration(
                  hintText:"Entrer votre mot de passe",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  )
              ),
              onChanged :(String texte){
                setState((){
                  password = texte;
                });
              }
          ),

          const SizedBox(height : 40),

    // Bouton
          Row(
              mainAxisAlignment : MainAxisAlignment.center,
              children : [
                ElevatedButton(
                    onPressed:(){
                      if(selections[0] == true){
                        FirestoreHelper().Inscription(prenom, nom, mail, password).then((value){
                          Navigator.push(context,MaterialPageRoute(
                              builder : (context){
                                //return Dashboard(mail : mail,password : password);
                                return Dashboard();
                              }
                          ));
                        }).catchError((error){
                          print(error);
                        });
                      } else {
                        FirestoreHelper().Connexion(mail, password).then((value){
                          setState(() {
                            Myprofil = value;
                            Navigator.push(context,MaterialPageRoute(
                                builder : (context){
                                  return Dashboard();
                                }
                            ));
                          });
                        }).catchError((error){
                          print(error);
                        });
                      }
                    },
                    child : const Text("Validation")

                ),
                const SizedBox(width : 10),
              ]
          ),
        ]
    );
  }
}
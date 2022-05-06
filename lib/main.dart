import 'package:flutter/foundation.dart';
import 'package:ms_haine/Fonctions/FirestoreHelper.dart';
import 'package:ms_haine/Fonctions/CustomHelper.dart';
import 'package:ms_haine/View/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'library/lib.dart';
import 'package:awesome_icons/awesome_icons.dart';

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
        scaffoldBackgroundColor: Colors.blueGrey,
        primarySwatch: Colors.amber,
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
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: CustomHelper().leadingCustomAppBar(),
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
                  icon: const Icon(FontAwesomeIcons.user),
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
                  icon: const Icon(FontAwesomeIcons.user),
                  hintText:"Entrer votre nom de famille",
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
                  icon: const Icon(FontAwesomeIcons.at),
                  hintText:"Entrer votre adresse mail",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  ),
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
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  icon: const Icon(FontAwesomeIcons.lock),
                  hintText: "Entrer votre mot de passe",
                  border : OutlineInputBorder(
                      borderRadius : BorderRadius.circular(20)
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
              ),
              onChanged: (String texte) {
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
                ElevatedButton.icon(
                    onPressed: (){
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
                          CustomHelper().dialogue(context);
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
                          CustomHelper().dialogue(context);
                        });
                      }
                    },
                  icon: const Icon(FontAwesomeIcons.check),
                  label : (selections[0]) ? const Text("S'enregistrer") : const Text("Se connecter"),
                ),

                const SizedBox(width : 10),

              ]
          ),
        ]
    );
  }
}
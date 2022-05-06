import 'package:ms_haine/main.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:ms_haine/Fonctions/CustomHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ms_haine/Controller/MessageControler.dart';
import 'package:ms_haine/Fonctions/FirestoreHelper.dart';
import 'package:ms_haine/library/constant.dart';
import 'package:ms_haine/model/MyProfil.dart';
import 'package:ms_haine/modelView/ImageRond.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllUsersState();
  }
}

class AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return bodyPage();
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fireUser.snapshots(),
        builder: (context, snapshot) {
          // Pas d'information dans la collection Users
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  MyProfil users = MyProfil(documents[index]);
                  if (users.uid == Myprofil.uid) {
                    return Container();
                  } else {
                    return InkWell(
                      child: Card(
                        elevation: 5.0,
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: ImageRond(image: users.image, size: 60),
                          title: Text("${users.prenom} ${users.nom}"),
                          subtitle: Text(users.mail),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Scaffold(
                              appBar: AppBar(
                                leading: InkWell(
                                    child: CustomHelper().leadingCustomAppBar(),
                                    onTap: () {
                                      print("coucou");
                                      Navigator.pop(context);
                                    }),
                                title:
                                    Text(Myprofil.prenom + " " + Myprofil.nom),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      FirestoreHelper().deconnexion();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const MyHomePage(
                                            title: "MS Haine");
                                      }));
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                    icon: const Icon(
                                        FontAwesomeIcons.arrowCircleRight),
                                    label: const Text("Deconnexion"),
                                  )
                                ],
                              ),
                              body: Column(children: [
                                MessageController(Myprofil, users),
                                // ZoneText(users, Myprofil),
                              ]),
                              bottomNavigationBar: BottomAppBar(
                                child: ZoneText(users, Myprofil),
                              ));
                        }));
                      },
                    );
                  }
                });
          }
        });
  }
}

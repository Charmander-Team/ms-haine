import 'dart:js';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ms_haine/model/MyProfil.dart';

class FirestoreHelper {

  //Attributs
  final auth = FirebaseAuth.instance;
  final fireUser = FirebaseFirestore.instance.collection("Users");
  final storage = FirebaseStorage.instance;

  final fire_message = FirebaseFirestore.instance.collection("Message");
  final fire_conversation=FirebaseFirestore.instance.collection('Conversations');

  addMessage(Map<String,dynamic> map,String uid){
    fire_message.doc(uid).set(map);
  }
  addConversation(Map<String,dynamic> map,String uid){
    fire_conversation.doc(uid).set(map);
  }

  sendMessage(String texte, MyProfil user, MyProfil moi) {
    DateTime date = DateTime.now();
    Map <String, dynamic>map = {
      'from': moi.uid,
      'to': user.uid,
      'texte': texte,
      'envoiMessage': date
    };

    String idDate = date.microsecondsSinceEpoch.toString();

    addMessage(map, getMessageRef(moi.uid, user.uid, idDate));
    addConversation(getConversation(moi.uid, user, texte, date), moi.uid);
    addConversation(getConversation(user.uid, moi, texte, date), user.uid);
  }

  Map <String,dynamic> getConversation(String sender,MyProfil partenaire,String texte,DateTime date){
    Map <String,dynamic> map = partenaire.toMap();
    map ['idmoi']=sender;
    map['lastmessage']=texte;
    map['envoimessage']=date;
    map['destinateur']=partenaire.uid;
    return map;
  }

  String getMessageRef(String from,String to,String date){
    String resultat="";
    List<String> liste=[from,to];
    liste.sort((a,b)=>a.compareTo(b));
    for(var x in liste){
      resultat += x+"+";
    }
    resultat =resultat + date;
    return resultat;
  }

  //Méthodes

  // fonction pour s'inscrire
  Future Inscription(String prenom , String nom , String mail , String password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: mail, password: password);
    String uid = result.user!.uid;
    Map<String,dynamic> map = {
      "PRENOM" : prenom,
      "NOM" : nom,
      "MAIL": mail,
    };
    addUser(uid, map);

  }


  //Fonction pour se conneter
  Future <MyProfil> Connexion( String mail , String password) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: mail, password: password);
    String uid = result.user!.uid;
    DocumentSnapshot snapshot = await fireUser.doc(uid).get();
    return MyProfil(snapshot);
  }


  //Créer un utilisateur dans la base donnée

  addUser(String uid , Map<String,dynamic> map){
    fireUser.doc(uid).set(map);
  }


  //Mettre à jour l'utilisateur
  updateUser(String uid , Map<String,dynamic> map){
    fireUser.doc(uid).update(map);
  }


  deconnexion(){
    auth.signOut();
  }


  //Stocker image
  Future <String> stockageImage(String nameImage,Uint8List data) async{
    String urlChemin = "";
    //Stocker l'image
    TaskSnapshot download = await storage.ref("image/$nameImage").putData(data);
    //Récupper le lien de l'image
    urlChemin = await download.ref.getDownloadURL();
    return urlChemin;
  }

}
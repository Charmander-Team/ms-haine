import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ms_haine/Fonctions/FirestoreHelper.dart';
import 'package:ms_haine/model/Message.dart';
import 'package:ms_haine/model/MyProfil.dart';

class MessageController extends StatefulWidget {

  MyProfil id;
  MyProfil idPartner;

  MessageController(@required this.id, @required this.idPartner);

  @override
  State<StatefulWidget> createState() {
    return MessageControllerState();
  }
} // Fin de MessageController

class MessageControllerState extends State<MessageController> {

  late Animation animation;
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fire_message.orderBy('envoiMessage',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot>snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List<DocumentSnapshot>documents = snapshot.data!.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext ctx,int index) {
                Message discussion = Message(documents[index]);
                if ((discussion.from == widget.id.uid && discussion.to == widget.idPartner.uid) || (discussion.from == widget.idPartner.uid && discussion.to == widget.id.uid)) {
                  return messageBubble(widget.id.uid, widget.idPartner, discussion);
                } else {
                  return Container();
                }
              }
            );
          } // Fin de ELSE
        } // Fin de builder
    );
  }

} // Fin de MessageControllerState

class messageBubble extends StatelessWidget {

  Message message;
  MyProfil partenaire;
  String monId;
  Animation? animation;

  messageBubble(@required this.monId, @required this.partenaire, @required this.message, {this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: widgetBubble(message.from == monId),
      ),
    );
  }

  List<Widget> widgetBubble(bool moi) {
    CrossAxisAlignment alignment = (moi) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color colorBubble = (moi) ? Colors.green : Colors.blue;
    Color textcolor = Colors.white;
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: colorBubble,
              child: Container(
                padding: EdgeInsets.all( (animation?.value != null) ? animation?.value : 6.0 ),
                child: Text(
                 message.envoiMessage.toString()+":\n"+message.texte,
                  style: TextStyle(color: textcolor),
                ),
              ),
            ),
          ],
        ),
      )
    ];
  } // Fin de LIST

} // Fin de messageBubble

class ZoneText extends StatefulWidget {

  MyProfil partenaire;
  MyProfil moi;

  ZoneText(@required this.partenaire, @required this.moi);

  @override
  State<StatefulWidget> createState() {
    return ZoneTextState();
  }

} // Fin de messageBubble

TextEditingController _textEditingController = TextEditingController();

class ZoneTextState extends State<ZoneText>{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration.collapsed(hintText: "??crivez votre message ?? ${widget.partenaire.prenom} ${widget.partenaire.nom}"),
              maxLines: null,
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendBouttonpressed)
        ],
      ),
    );
  }

  _sendBouttonpressed() {
    if (_textEditingController != "") {
      String text=_textEditingController.text;
      print('enregistrement');
      FirestoreHelper().sendMessage(text, widget.partenaire,widget.moi);

      setState(() {
        _textEditingController.text='';
      });

      FocusScope.of(context).requestFocus(FocusNode());

      _sendMessage();
    }
  }

  _sendMessage() {
    //envoie message dans firebase
    print(_textEditingController.text);
  }

} // Fin de ZoneTextState
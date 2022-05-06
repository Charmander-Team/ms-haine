import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ms_haine/model/Message.dart';
import 'package:ms_haine/model/MyProfil.dart';

class MessageController extends StatefulWidget{
  MyProfil id;
  MyProfil idPartner;
  MessageController(@required MyProfil this.id,@required MyProfil this.idPartner);
  @override
  State<StatefulWidget> createState() {
    return MessageControllerState();
  }
}

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
        stream: restoreHelper(). re_message.orderBy('envoiMessage',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot>snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List<DocumentSnapshot>documents = snapshot.data!.docs;


            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext ctx,int index) {
                Message discussion = Message(documents[index]);
                if ((discussion.from == widget.id.uid &&
                    discussion.to == widget.idPartner.uid) ||
                    (discussion.from == widget.idPartner.uid &&
                        discussion.to == widget.id.uid)) {
                  return messageBubble(
                    widget.id.uid, widget.idPartner, discussion,);
                } else {
                  return Container();
                }
              }
            );
          } // Fin de ELSE
        } // Fin de builder
    );
  }
}



class messageBubble extends StatelessWidget {

  Message message;
  MyProfil partenaire;String monId;
  Animation? animation;

  messageBubble(@required String this.monId,@required MyProfil this.partenaire,@required Message this.message,{Animation? this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: widgetBubble(message.from==monId),
      ),
    );
  }

  List<Widget> widgetBubble(bool moi) {
    CrossAxisAlignment alignment =
        (moi) ? CrossAxisAlignment.end : CrossAxisAlignment.start;
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
                padding: EdgeInsets.all(animation?.value),
                child: Text(
                  message.texte,
                  style: TextStyle(color: textcolor),
                ),
              ),
            ),
          ],
        ),
      )
    ];
  } // Fin de LIST
}


class ZoneText extends StatefulWidget {

  MyProfil partenaire;
  MyProfil moi;

  ZoneText(@required MyProfil this.partenaire, @required MyProfil this.moi);

  @override
  State<StatefulWidget> createState() {
    return ZoneTextState();
  }

}


TextEditingController _textEditingController = new TextEditingController();

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
              decoration: const InputDecoration.collapsed(hintText: "écrivez votre message",),
              maxLines: null,
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendBouttonpressed)
        ],
      ),
    );
  }

  _sendBouttonpressed() {
    if(_textEditingController != null && _textEditingController != ""){
      String text=_textEditingController.text;
      print('enregistrement');
      restoreHelper().sendMessage(text, widget.partenaire,widget.moi);

      setState(() {
        _textEditingController.text='';
      });

      FocusScope.of(context).requestFocus(new FocusNode());

      _sendMessage();
    }
  }

  _sendMessage(){
    //envoie message dans rebase
    print(_textEditingController.text);
  }

}
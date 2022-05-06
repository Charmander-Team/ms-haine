import 'package:awesome_icons/awesome_icons.dart';
import 'package:ms_haine/View/AllUsers.dart';
import 'package:ms_haine/View/MyUsers.dart';
import 'package:flutter/material.dart';
import 'package:ms_haine/Fonctions/FirestoreHelper.dart';
import 'package:ms_haine/main.dart';

class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState()=> DashboardState();

}

class DashboardState extends State<Dashboard>{

  int selected = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar : AppBar(
            title : const Text("Mon DashBoard"),
            actions: [
                IconButton(onPressed: (){
                  FirestoreHelper().deconnexion();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const MyHomePage(title: "");
                      }
                  ));
                },
                    icon: const Icon(Icons.exit_to_app ,color: Colors.red,)
                )
            ],
        ),
        body : bodyPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected,
          onTap: (newValue){
            setState(() {
              selected = newValue;
              controller.jumpToPage(newValue);
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.users),
                label: "Utilisateurs"
            ),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userEdit),
                label : "Profil"
            )
          ],
        ),
    );
  }

  Widget bodyPage(){
    return PageView(
      onPageChanged: (value){
        setState(() {
          selected = value;
        });
      },
      children: [
        AllUsers(),
        MyUsers()
      ],
      controller: controller,
    );
  }

}
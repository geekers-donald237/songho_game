import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:songhogame/models/online_page.dart';
import 'package:songhogame/views/menuJeu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('players');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF536DFE), Color(0xFF7C4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: kToolbarHeight + 30,
        shape: CustomShapeBorder(),
        actions: [
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: playersCollection.doc(user.uid).get()
                as Future<DocumentSnapshot<Map<String, dynamic>>>,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data();
                String? downloadURL = data?['pathPhoto'];
                String? username = data?['usernameP1'];

                return Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              username ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Online',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: Center(
                          child: downloadURL != null
                              ? ClipOval(
                                  child: Image.network(
                                    downloadURL,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Colors.white, 
                                  ),
                                  onPressed: () {},
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error');
                
              }
              return SizedBox.shrink();
            },
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Get.to(() => MenuJeu());
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 30);
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double radius = 50;
    final double topMargin = 30;

    Path path = Path();

    path.lineTo(0, rect.height - radius);
    path.quadraticBezierTo(rect.width / 2, rect.height + topMargin, rect.width,
        rect.height - radius);
    path.lineTo(rect.width, 0);
    path.close();

    return path;
  }
}

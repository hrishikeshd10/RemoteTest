import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_neighbourhood_online/Utilities/key_constants.dart';
import 'package:my_neighbourhood_online/api_response_model/notification_model.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  void getNotifications() async {
    print("inside Notifications");
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> notificationStringList =
        pref.getStringList(SPKeys.notificationList);

    if (notificationStringList != null) {
      setState(() {
        notifications.clear();
        notificationStringList.forEach((element) {
          NotificationModel notificationModel =
              notificationModelFromJson(element);
          notifications.add(notificationModel);
        });
      });
    }

    print(notifications.length);
  }

  @override
  Widget build(BuildContext context) {
    getNotifications();
    controller.add(false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff202427),
          leading: GestureDetector(
            child: Image.asset('assets/images/back_arrow.png'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Notifications".capitalize(),
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
        ),
        body: BaseCanvas(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      "There are no current notifications!",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, i) => ListTile(
                          // title: Text(notifications[i].title ?? ""),
                          subtitle: Text(
                            notifications[i].body ?? "",
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                    separatorBuilder: (context, i) => Divider(
                          color: Colors.grey,
                        ),
                    itemCount: notifications.length),
          ),
        ));
  }
}

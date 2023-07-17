import 'package:flutter/material.dart';

class NotificationPanel extends StatefulWidget {
  final String tripID;
  final String tripType;
  final String tripName;
  final String message;
  final String avatar_url;
  final bool viewed;

  const NotificationPanel(
      {Key? key,
      required this.tripID,
      required this.tripName,
      required this.tripType,
      required this.avatar_url,
      required this.message,
      required this.viewed})
      : super(key: key);

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  Map<String, Color> mTripColor = {
    "": Colors.black,
    "start": Colors.blue,
    "pending": Colors.orange,
    "accept": Colors.brown,
    "finish": Colors.green,
    "cancel": Colors.purple,
    "reject": Colors.red,
  };

  Map<String, String> mTripDesc = {
    "": "",
    "start": "Trip has been started",
    "pending": "New pending trip",
    "accept": "Trip has been accepted",
    "finish": "Trip has been finished",
    "cancel": "Trip has been cancelled",
    "reject": "Trip has been rejected",
  };

  @override
  Widget build(BuildContext context) {
    String avatar = widget.avatar_url;
    if (avatar == "http://167.86.102.230/alnabali/public/uploads/image/") {
      avatar =
          "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
    }

    List<String> message = widget.message.split(" ");
    message.removeLast();
    String modifiedMessage = "${message.join(" ")} ${widget.tripName}";

    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 10,
      child: Container(
        decoration: BoxDecoration(
            color: this.widget.viewed ? Colors.white : Color(0XFFfcdcc5),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 109, 108, 108),
                  blurRadius: 15,
                  offset: Offset(2, 2))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Colors.black45)),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                      onBackgroundImageError: (exception, stackTrace) {
                        setState(() {
                          avatar =
                              "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
                        });
                      },
                      backgroundColor: Colors.transparent,
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.tripID,
                  style: TextStyle(
                      fontSize: 9,
                      fontFamily: 'Montserrat',
                      color: Color.fromRGBO(244, 130, 34, 1),
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tripName,
                  style: TextStyle(
                    color: widget.viewed ? Colors.black : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Text(
                    modifiedMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.viewed ? Colors.black : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 0;

  List<NotificationItem> notifications = [
    NotificationItem(
        title: 'Assurance Vie',
        description: 'Votre police d\'assurance vie a été approuvée.',
        icon: Icons.favorite,
        color: Colors.purple,
        isRead: false),
    NotificationItem(
        title: 'Assurance Santé',
        description: 'Votre réclamation d\'assurance santé a été traitée.',
        icon: Icons.local_hospital,
        color: Colors.red,
        isRead: false),
    NotificationItem(
        title: 'Assurance Automobile',
        description: 'Votre police d\'assurance automobile est renouvelée.',
        icon: Icons.directions_car,
        color: Colors.teal,
        isRead: true),
    NotificationItem(
        title: 'Assurance Habitation',
        description:
            'Votre réclamation d\'assurance habitation a été approuvée.',
        icon: Icons.home,
        color: Colors.brown,
        isRead: true),
  ];

  List<NotificationItem> get unreadNotifications =>
      notifications.where((notification) => !notification.isRead).toList();

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> currentNotifications =
        _selectedIndex == 0 ? notifications : unreadNotifications;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              color: Color(0xFFf38f1d), // color of non-selected text
              selectedColor:
                  Color.fromARGB(255, 255, 255, 255), // color of selected text
              fillColor: Color(0xFFf38f1d), // no background color change
              borderColor: Color(0xFFf38f1d), // border color
              selectedBorderColor:
                  Color(0xFFf38f1d), // border color when selected
              borderWidth: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Toutes"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Non lues"),
                )
              ],
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: currentNotifications.isEmpty
                ? Center(
                    child: Text(
                      'Vous n\'avez pas de notifications',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentNotifications.length,
                    itemBuilder: (context, index) {
                      var notification = currentNotifications[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        color: notification.isRead
                            ? Colors.white
                            : Colors.grey[200],
                        child: ListTile(
                          leading: Stack(
                            children: [
                              Icon(notification.icon,
                                  color: notification.color),
                              if (!notification.isRead)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.brightness_1,
                                    size: 10,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold),
                          ),
                          subtitle: Text(notification.description),
                          trailing: notification.status != null
                              ? Text(
                                  notification.status!,
                                  style: TextStyle(
                                    color: notification.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ''),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation item tap
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? status;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.status,
    this.isRead = false,
  });
}

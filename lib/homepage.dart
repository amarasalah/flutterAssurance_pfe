import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              // Wrap the top bar in ClipRRect to apply border radius
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF38F1D),
                        const Color(0xFFEE5E1B)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  height: 150, // Height of the top bar

                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('editProfile');
                        },
                        child: CircleAvatar(
                          radius: 35.0, // Larger avatar
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150'), // Replace with actual image URL
                        ),
                      ),
                      SizedBox(width: 20.0), // Space between avatar and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center align text vertically
                        children: [
                          Text(
                            'Bienvenue de retour',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white, // White text color
                            ),
                          ),
                          Text(
                            'Nila Ali Khan',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text color
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.notifications,
                            color: Colors.white), // White icon color
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app,
                            color: Colors.white), // White icon color
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "login", (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        _buildGradientCard(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.yellow],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: 'Assurance Santé',
                          subtitle: 'Voir toutes vos assurances ici',
                          icon: Icons.health_and_safety,
                          onTap: () {
                            Navigator.of(context).pushNamed('/healthInsurance');
                          },
                        ),
                        _buildGradientCard(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: 'Assurance Auto',
                          subtitle: 'Voir toutes vos assurances ici',
                          icon: Icons.directions_car,
                          onTap: () {
                            Navigator.of(context).pushNamed('/autoInsurance');
                          },
                        ),
                        _buildGradientCard(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: 'Assurance Habitation',
                          subtitle: 'Voir toutes vos assurances ici',
                          icon: Icons.home,
                          onTap: () {
                            Navigator.of(context).pushNamed('/homeInsurance');
                          },
                        ),
                        _buildGradientCard(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromRGBO(156, 39, 176, 1),
                              Colors.deepPurple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: 'Assurance Vie',
                          subtitle: 'Voir toutes vos assurances ici',
                          icon: Icons.favorite,
                          onTap: () {
                            Navigator.of(context).pushNamed('/lifeInsurance');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard({
    required Gradient gradient,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            trailing: Icon(
              icon,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}

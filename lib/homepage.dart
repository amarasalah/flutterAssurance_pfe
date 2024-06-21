import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insurance_pfe/historique.dart';
import 'package:insurance_pfe/nos_agences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !user.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("login");
      });
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Widget> pages = [
      _buildHomePage(context, user),
      Nosagences(),
      HistoriqueScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[myCurrentIndex]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: myCurrentIndex,
            onTap: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Carte',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, User user) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF38F1D), const Color(0xFFEE5E1B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: 150,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('editProfile');
                  },
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(
                        user.photoURL ?? 'https://via.placeholder.com/150'),
                  ),
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenue de retour',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.displayName ?? 'Utilisateur',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
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
                      colors: [
                        Colors.orange.withOpacity(0.9),
                        Colors.yellow.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Santé',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.health_and_safety,
                    onTap: () {
                      Navigator.of(context).pushNamed('health');
                    },
                    imageUrl: 'images/health.jpg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.9),
                        Colors.lightGreen.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Auto',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.directions_car,
                    onTap: () {
                      Navigator.of(context).pushNamed('car');
                    },
                    imageUrl: 'images/images.jpeg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.9),
                        Colors.lightBlue.withOpacity(0.4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Habitation',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.home,
                    onTap: () {
                      Navigator.of(context).pushNamed('home');
                    },
                    imageUrl: 'images/home.jpeg',
                  ),
                  _buildGradientCard(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromRGBO(156, 39, 176, 1).withOpacity(0.9),
                        Colors.deepPurple.withOpacity(0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: 'Assurance Vie',
                    subtitle: 'Voir toutes vos assurances ici',
                    icon: Icons.favorite,
                    onTap: () {
                      Navigator.of(context).pushNamed('life');
                    },
                    imageUrl: 'images/life.jpeg',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientCard({
    required Gradient gradient,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required String imageUrl,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              gradient: gradient,
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
        ));
  }
}

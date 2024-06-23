import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class HistoriqueScreen extends StatefulWidget {
  @override
  _HistoriqueScreenState createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [
    {
      'id': 'Contrat Assurance maladie ',
      'type': 'maladie',
      'agence': 'Agence Zeineb Gabes',
      'date': DateTime.now(),
      'status': 'en attente'
    },
    {
      'id': 'Contrat Assurance vie',
      'type': 'vie',
      'agence': 'Agence Tunis',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'en cours'
    },
    {
      'id': 'Contrat Assurance vehicule',
      'type': 'vehicule',
      'agence': 'Agence Sfax',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'status': 'payee'
    },
    {
      'id': 'Contrat Assurance habitation',
      'type': 'habitation',
      'agence': 'Agence Bizerte',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'status': 'expiree'
    },
  ];
  late List<Map<String, dynamic>> _filteredItems;
  String _selectedType = 'All';
  final List<String> _filterTypes = [
    'All',
    'maladie',
    'vie',
    'vehicule',
    'habitation'
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this); // Change length to 5
    _tabController.addListener(_filterItems);
    _filteredItems = _items;
  }

  void _filterItems() {
    setState(() {
      String currentStatus;
      switch (_tabController.index) {
        case 0:
          currentStatus = 'All';
          break;
        case 1:
          currentStatus = 'payee';
          break;
        case 2:
          currentStatus = 'en attente';
          break;
        case 3:
          currentStatus = 'en cours';
          break;
        case 4:
          currentStatus = 'expiree';
          break;
        default:
          currentStatus = 'All';
      }
      _filteredItems = _items.where((item) {
        final matchesQuery = item['id']!.contains(_searchController.text);
        final matchesType =
            _selectedType == 'All' || item['type'] == _selectedType;
        final matchesStatus =
            currentStatus == 'All' || item['status'] == currentStatus;
        return matchesQuery && matchesType && matchesStatus;
      }).toList();
    });
  }

  void _filterByType(String selectedType) {
    setState(() {
      _selectedType = selectedType;
      _filterItems();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_filterItems);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Change length to 5
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Historique',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF38F1D), const Color(0xFFEE5E1B)],
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            indicatorColor: const Color(0xFFF38F1D),
            tabs: [
              Tab(text: 'Tous'), // Add "Tous" tab
              Tab(text: 'Payée'),
              Tab(text: 'En attente'),
              Tab(text: 'En cours'),
              Tab(text: 'Expirée'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (query) => _filterItems(),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filterTypes.map((type) {
                    final isSelected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => _filterByType(type),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF38F1D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFF38F1D)),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFF38F1D),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListView(),
                    _buildListView(),
                    _buildListView(),
                    _buildListView(),
                    _buildListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return HistoriqueCard(item: _filteredItems[index]);
      },
    );
  }
}

class HistoriqueCard extends StatelessWidget {
  final Map<String, dynamic> item;

  HistoriqueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['id']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 231, 206, 190),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    item['status']!,
                    style: TextStyle(
                        color: Color(0xFFEE5E1B), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text('No: #17016284350965'),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.contact_page, color: Colors.yellow[700]),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text('Type:\n ${item['type']}'),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.location_on, color: Colors.yellow[700]),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(item['agence']!),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black54),
                SizedBox(width: 8.0),
                Text(DateFormat(
                  'dd MMM, HH:mm',
                ).format(item['date'])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

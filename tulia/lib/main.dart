// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(LoaningSystemApp());
}

class LoaningSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kenya Loaning System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    LoansPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kenya Loaning System'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Loans'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/* ---------------- Home Page ---------------- */
class HomePage extends StatelessWidget {
  final List<LoanCategory> categories = [
    LoanCategory(
        title: "Water Bill Loan",
        icon: Icons.water_drop,
        description: "Pay your Nairobi Water or local water provider."),
    LoanCategory(
        title: "KPLC Bill Loan",
        icon: Icons.flash_on,
        description: "Clear your Kenya Power (KPLC) electricity bills."),
    LoanCategory(
        title: "House Rent Loan",
        icon: Icons.house,
        description: "Pay your monthly rent with flexible repayment."),
    LoanCategory(
        title: "School Fees Loan",
        icon: Icons.school,
        description: "Support education with instant school fees loans."),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Available Loan Categories",
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LoanApplicationPage(category: category)));
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary),
                          SizedBox(height: 12),
                          Text(category.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center),
                          SizedBox(height: 8),
                          Text(category.description,
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class LoanCategory {
  final String title;
  final IconData icon;
  final String description;
  LoanCategory(
      {required this.title, required this.icon, required this.description});
}

/* ---------------- Loan Application Page ---------------- */
class LoanApplicationPage extends StatefulWidget {
  final LoanCategory category;
  LoanApplicationPage({required this.category});

  @override
  _LoanApplicationPageState createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _accountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Loan request submitted for ${widget.category.title} (KES ${_amountCtrl.text})"),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Apply for ${widget.category.title}",
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Loan Amount (KES)",
                    border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter loan amount" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _accountCtrl,
                decoration: InputDecoration(
                    labelText: "Account / Meter / School ID",
                    border: OutlineInputBorder()),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter relevant account" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(Icons.send),
                label: Text("Submit Loan Request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Loans Page ---------------- */
class LoansPage extends StatelessWidget {
  final List<Map<String, dynamic>> pastLoans = [
    {"type": "KPLC Bill Loan", "amount": 2500, "status": "Approved"},
    {"type": "School Fees Loan", "amount": 15000, "status": "Pending"},
    {"type": "Water Bill Loan", "amount": 1200, "status": "Paid"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(14),
      itemCount: pastLoans.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, i) {
        final loan = pastLoans[i];
        return ListTile(
          leading: Icon(Icons.monetization_on_outlined,
              color: Theme.of(context).colorScheme.primary),
          title: Text(loan['type']),
          subtitle: Text("KES ${loan['amount']}"),
          trailing: Text(loan['status'],
              style: TextStyle(
                  color: loan['status'] == "Approved"
                      ? Colors.green
                      : loan['status'] == "Pending"
                          ? Colors.orange
                          : Colors.grey)),
        );
      },
    );
  }
}

/* ---------------- Profile Page ---------------- */
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 45,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 12),
            Text("Patience Wangui",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 6),
            Text("Kenya Loaning System User"),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.settings),
              label: Text("Account Settings"),
            ),
            SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout),
              label: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}

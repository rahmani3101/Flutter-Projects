import 'package:flutter/material.dart';

void main() {
  runApp(const VoterEligibilityApp());
}

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}

class VoterEligibilityApp extends StatelessWidget {
  const VoterEligibilityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voter Eligibility',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const VoterListPage(),
    );
  }
}

class VoterListPage extends StatefulWidget {
  const VoterListPage({Key? key}) : super(key: key);

  @override
  _VoterListPageState createState() => _VoterListPageState();
}

class _VoterListPageState extends State<VoterListPage> {
  final List<Person> _people = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  void _addPerson() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _people.add(
          Person(
            _nameController.text,
            int.parse(_ageController.text),
          ),
        );
        _nameController.clear();
        _ageController.clear();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eligibleVoters = _people.where((person) => person.age >= 18).toList();

    final ineligibleVoters =
        _people.where((person) => person.age < 18).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Eligibility Manager'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an age';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _addPerson,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Person'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildListSection(
                'Eligible Voters (18+)',
                eligibleVoters,
                Colors.green,
                Icons.how_to_vote,
              ),
              const SizedBox(height: 16),
              _buildListSection(
                'Ineligible Voters',
                ineligibleVoters,
                Colors.red,
                Icons.person_off,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListSection(
    String title,
    List<Person> people,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${people.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (people.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No people in this category',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: people.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Text(
                      people[index].name[0],
                      style: TextStyle(color: color),
                    ),
                  ),
                  title: Text(people[index].name),
                  subtitle: Text('Age: ${people[index].age}'),
                  trailing: Icon(Icons.person, color: color.withOpacity(0.5)),
                );
              },
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TipCalculatorScreen(),
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  @override
  _TipCalculatorScreenState createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billAmountController =
      TextEditingController(); // Correct variable name
  double _tipPercentage = 15.0; // Default tip percentage
  double _tipAmount = 0.0;
  double _totalAmount = 0.0;

  final List<double> _tipOptions = [5.0, 10.0, 15.0, 20.0, 25.0];

  void _calculateTip() {
    if (_formKey.currentState!.validate()) {
      double billAmount = double.tryParse(_billAmountController.text) ?? 0.0;
      setState(() {
        _tipAmount = (billAmount * _tipPercentage) / 100;
        _totalAmount = billAmount + _tipAmount;
      });
    }
  }

  void _resetData() {
    setState(() {
      _billAmountController.clear();
      _tipPercentage = 15.0;
      _tipAmount = 0.0;
      _totalAmount = 0.0;
    });
  }

  @override
  void dispose() {
    _billAmountController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bill Amount Input
              TextFormField(
                controller: _billAmountController, // Correct variable name
                decoration: InputDecoration(
                  labelText: 'Bill Amount (INR)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the bill amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Tip Percentage Selection
              Text(
                'Select Tip Percentage:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: _tipOptions.map((percentage) {
                  return ChoiceChip(
                    label: Text('$percentage%'),
                    selected: _tipPercentage == percentage,
                    onSelected: (selected) {
                      setState(() {
                        _tipPercentage = percentage;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Calculate and Reset Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _calculateTip,
                    child: Text('Calculate Tip'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _resetData,
                    child: Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Display Results
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Tip Amount: ₹${_tipAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total Bill: ₹${_totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

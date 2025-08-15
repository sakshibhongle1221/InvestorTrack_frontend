import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _transactions = [];
  final List<String> _transactionTypes = ['expense','income'];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final transactions = await _apiService.getTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load transactions: $e')),
        );
      }
    }
  }

  Future<void> _showAddTransactionDialog() async {
    final descriptionController = TextEditingController(); 
    final amountController = TextEditingController();
    final categoryController = TextEditingController();
    // String transactionType = 'expense';
    // String category = 'other';
    // String category = 'food';
    String? selectedType = 'expense';

    return showDialog<void>(
      context: context,
      builder:(BuildContext context){
        return StatefulBuilder(
         builder: (context,setState){
          return AlertDialog(
          title: const Text('Add New Transaction'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText:"Description"),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(hintText:"Amount"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _transactionTypes.map((String type){
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.isNotEmpty ? type[0].toUpperCase() + type.substring(1): ''),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState((){
                    selectedType = newValue;
                  });
                },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(hintText: "Category"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
            child: const Text('cancel'),
            onPressed:(){
              Navigator.of(context).pop(); 
            },  
            ),
            TextButton(
              child: const Text('Save'),
              onPressed:() async{

                if(amountController.text.isEmpty || categoryController.text.isEmpty || selectedType == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                } 
                try{
                  await _apiService.addTransaction(double.parse(amountController.text),
                  selectedType!,
                  categoryController.text,descriptionController.text
                  );
                  if (mounted) {
                    Navigator.of(context).pop();
                    _fetchTransactions();
                  }
                }
                catch (e) {
                  if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add transaction: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
      },
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar is now in MainScreen, so we don't need one here.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
        
                final DateTime date = DateTime.parse(transaction['created_at']);
                final String formattedDate = DateFormat('MMMM d, yyyy').format(date);

                return Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      transaction['type'] == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
                      color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction['description'] ?? 'No description', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(formattedDate),
                    trailing: Text(
                      '₹${transaction['amount']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),


            floatingActionButton: FloatingActionButton(
                onPressed: _showAddTransactionDialog,
                tooltip: 'Add Transaction',
                child: const Icon(Icons.add),
            ),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/api_service.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState()=> _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _transactions = [];
  List<dynamic> _summaryData = [];

  @override
  void initState(){
    super.initState();
    _fetchData();
  }

  Future<void>_fetchData() async{
    setState((){
      _isLoading = true;
    });
    try{
      final results = await Future.wait([ 
      _apiService.getTransactions(),
      _apiService.getTransactionSummary(),
      ]);
      setState((){
       _transactions= results[0];
        _summaryData = results[1];
       _isLoading =false;        
      });
    }
    catch(e){
      setState((){
        _isLoading = false;
      });
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dashboard data:$e')),
        );
      }
    }
  }

  Future<void> _showAddTransactionDialog() async {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    String transactionType = 'expense';
    //String category = 'other';
    String category = 'food';

    return showDialog<void>(
      context: context,
      builder:(BuildContext context){
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
                try{
                  await _apiService.addTransaction(double.parse(amountController.text),
                  transactionType,
                  category,descriptionController.text
                  );
                  if (mounted) {
                    Navigator.of(context).pop();
                    _fetchData();
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
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('My Dashboard'),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_balance_wallet),
          tooltip: 'Budgets',
          onPressed: () {
            Navigator.pushNamed(context, '/budgets');
          },
        ),
      ],
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView( // Use ListView to allow scrolling
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- SUMMARY CARDS (Placeholder) ---
              Row(
                children: [
                  Expanded(child: Card(child: ListTile(title: Text('Net Worth'), subtitle: Text('\$12,345')))),
                  Expanded(child: Card(child: ListTile(title: Text('Income'), subtitle: Text('\$5,678')))),
                  Expanded(child: Card(child: ListTile(title: Text('Expenses'), subtitle: Text('\$2,345')))),
                ],
              ),
              const SizedBox(height: 16),

              // --- EXPENSE SUMMARY CARD ---
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expense Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: _summaryData.map((item) {
                              return PieChartSectionData(
                                color: Colors.primaries[(_summaryData.indexOf(item)) % Colors.primaries.length],
                                value: double.parse(item['total_amount']),
                                title: '${item['category']}',
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- RECENT TRANSACTIONS CARD ---
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      // We use ...map here because it's already inside a scrolling ListView
                      ..._transactions.take(5).map((transaction) {
                          return ListTile(
                            title: Text(transaction['description'] ?? 'No description'),
                            subtitle: Text(transaction['category'] ?? 'Uncategorized'),
                            trailing: Text(
                              '₹${transaction['amount']}',
                              style: TextStyle(
                                color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddTransactionDialog,
      tooltip: 'Add Transaction',
      child: const Icon(Icons.add),
    ),
  );
}

}

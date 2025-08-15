import 'package:flutter/material.dart';
import 'services/api_service.dart';

class BudgetsScreen extends StatefulWidget{
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen>{
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _budgets = [];

  @override
  void initState(){
    super.initState();
    _fetchBudgets();
  }
  Future<void> _fetchBudgets() async{
    try{
      final budgets = await _apiService.getBudgets();
      setState((){
        _budgets = budgets;
        _isLoading= false;
      });
    }
    catch(e){
      setState((){
        _isLoading= false;
      });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load budgets: $e')),
        );
      }
    }
  }


  Future<void> _showAddBudgetDialog() async{
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final monthController = TextEditingController(text: '08/2025');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Add New Budget'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(hintText: "Category (e.g., Food)"),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(hintText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: monthController,
                  decoration: const InputDecoration(hintText: "Month (YYYY-MM)"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed:() async{
                try{
                  await _apiService.addBudget(
                    categoryController.text,
                    double.parse(amountController.text),
                    monthController.text,
                  );
                  if(mounted){
                    Navigator.of(context).pop();
                    _fetchBudgets();
                  }
                }
                catch(e){
                  if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add transaction: $e')),
                    );
                  }
                }
              }
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budgets'),
      ),
      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _budgets.length,
        itemBuilder: (context,index){
          final budget = _budgets[index];
          return Card(
            elevation:2.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            margin: const EdgeInsets.symmetric(vertical:8.0),
            child: ListTile(
              title: Text(budget['category'],style: const TextStyle(fontWeight:FontWeight.bold)),
              subtitle: Text('Month: ${budget['month']}'),
              trailing: Text('₹${budget['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddBudgetDialog,
      tooltip: 'Add Budget',
      child: const Icon(Icons.add),
    )
    );
  }

}
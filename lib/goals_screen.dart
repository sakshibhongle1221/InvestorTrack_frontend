import 'package:flutter/material.dart';
import 'services/api_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _goals = [];

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    try {
      final goals = await _apiService.getGoals();
      setState(() {
        _goals = goals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load goals: $e')),
        );
      }
    }
  }


  Future<void> _showAddGoalDialog() async{
    final titleController = TextEditingController();
    final targetAmountController = TextEditingController();
    final targetDateController = TextEditingController(text:'2025-12-31');

    return showDialog<void>(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: SingleChildScrollView(
            child: ListBody(
              children:<Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText:"Your Goal Title (e.g, New Car)"),
                ),
                TextField(
                  controller: targetAmountController,
                  decoration: const InputDecoration(hintText:"Target Amount"),
                ),
                TextField(
                  controller: targetDateController,
                  decoration: const InputDecoration(hintText:"Target Date (YYYY-MM-DD)"),
                ),
              ],
            )
          ),
          actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: ()=> Navigator.of(context).pop(),
          ),
          TextButton(
             child: const Text('Save'),
             onPressed: () async{
              try{
                await _apiService.addGoal(
                  titleController.text,
                  double.parse(targetAmountController.text),
                  targetDateController.text,
                );
                if(mounted){
                  Navigator.of(context).pop();
                  _fetchGoals();
                }
              }
              catch(e){
                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add transaction: $e')),
                  );
                }
              }
             },
          ),
        ],

        );

      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Financial Goals'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final goal = _goals[index];

                final double currentAmount = double.tryParse(goal['current_amount'] ?? '0') ?? 0.0;
                final double targetAmount = double.tryParse(goal['target_amount'] ?? '0') ?? 0.0;
                final double progress = targetAmount > 0 ? currentAmount / targetAmount : 0;

                return Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Target: ₹${targetAmount.toStringAsFixed(0)}'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('${(progress * 100).toStringAsFixed(1)}% complete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: _showAddGoalDialog,
              tooltip: 'Add Goal',
              child: const Icon(Icons.add),
            ),
    );
  }
}
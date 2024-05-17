import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class AddTaskDialog extends StatefulWidget {
  final Function _addTask;

  const AddTaskDialog(this._addTask, {super.key});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _detailsController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'None';

  void _submitForm() {
    final todoDesc = _detailsController.text;
    _selectedDate = _selectedDate ?? DateTime.now();
    _selectedTime = _selectedTime ?? TimeOfDay.now();
    if (todoDesc.isEmpty) {
      return;
    } else {
      TodoTask newTask = TodoTask(
        id: DateTime.now().toString(),
        todoDetails: todoDesc,
        isCompleted: false,
        ondate: _selectedDate!,
        ontime: _selectedTime!,
        priority: _selectedPriority,
      );

      widget._addTask(newTask.todoDetails, newTask.ondate, newTask.ontime,
          newTask.priority);
      Navigator.of(context).pop();
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Add Todo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Please Provide details for todo',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: _detailsController,
                      decoration: const InputDecoration(
                        labelText: 'Todo Details',
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _selectedDate == null
                                ? 'No Date Chosen'
                                : DateFormat.yMd().format(_selectedDate!),
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.blueGrey),
                            onPressed: _showDatePicker,
                          ),
                        ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _selectedTime == null
                                ? 'No Time Chosen'
                                : _selectedTime?.format(context) ?? '',
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.blueGrey),
                            onPressed: _showTimePicker,
                          ),
                        ]),
                    Row(
                      children: <Widget>[
                        const Text('Priority:', style: TextStyle(fontSize: 20)),
                        Padding(
                          padding: const EdgeInsets.only(left: 200.0),
                          child: DropdownButton<String>(
                            value: _selectedPriority,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPriority = newValue!;
                              });
                            },
                            items: <String>['None', 'Low', 'Medium', 'High']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Add Todo',
                    style: TextStyle(color: Colors.white),
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

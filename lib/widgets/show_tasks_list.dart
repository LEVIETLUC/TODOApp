import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import './no_tasks.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  final List<TodoTask> _taskList;
  final Function _editTask;
  final Function _removeTask;
  final List<ValueNotifier<bool>> _isVisible;

  TaskList(this._taskList, this._editTask, this._removeTask)
      : _isVisible = List.generate(
          _taskList.length,
          (index) => ValueNotifier<bool>(true),
        );


  String _getPriorityIndicator(String priority) {
    switch (priority) {
      case 'High':
        return '!!!';
      case 'Medium':
        return '!!';
      case 'Low':
        return '!';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: _taskList.isEmpty
          ? NoTasks()
          : ListView.builder(
                itemBuilder: (ctx, index) {
                return Card(
                  color:Colors.white,
                  elevation: 4,
                  child: ListTile(
                    leading: Text(_getPriorityIndicator(_taskList[index].priority),
                        style: TextStyle(
                          fontSize: 20,
                          color: _taskList[index].isCompleted == true
                              ? Colors.grey
                              : _taskList[index].priority == 'High'
                                  ? Colors.red
                                  : _taskList[index].priority == 'Medium'
                                      ? Colors.orange
                                      :const Color.fromRGBO(225, 213, 7, 1.0),
                        )),
                    title: _taskList[index].isCompleted == true
                        ? Text(
                            _taskList[index].todoDetails,
                            style: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : Text(
                            _taskList[index].todoDetails,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${DateFormat.yMMMMd().format(_taskList[index].ondate)} ${_taskList[index].ontime.format(context)}',
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ValueListenableBuilder(
                          valueListenable: _isVisible[index],
                          builder: (context, value, child) {
                            return Builder(
                              builder: (context) {
                                return value
                                    ? IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        onPressed: () {
                                          _editTask(_taskList[index]);
                                        },
                                      )
                                    : Container();
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _taskList.length,
            ),
    );
  }
}
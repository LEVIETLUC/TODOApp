import 'package:flutter/material.dart';

class FilterListDialog extends StatelessWidget {
  final Function()? _sortPriority;
  final Function()? _sortDate;
  final Function()? _sortAZ;

  const FilterListDialog(this._sortPriority, this._sortDate, this._sortAZ, {super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Filter Todos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Please select filtering method',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.priority_high_outlined, color: Colors.grey),
                title: const Text(
                  'Filter By Priority',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: TextButton(
                  onPressed: _sortPriority,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.lightBlue
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.date_range, color: Colors.grey),
                title: const Text(
                  'Filter By Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: TextButton(
                  onPressed: _sortDate,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.lightBlue
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.title_outlined, color: Colors.grey),
                title: const Text(
                  'Filter By Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: TextButton(
                  onPressed: _sortAZ,
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.lightBlue
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

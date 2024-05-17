import 'package:flutter/material.dart';
import 'package:todo_app/splash_screen.dart';
import './widgets/show_tasks_list.dart';
import './widgets/add_task_dialog.dart';
import './widgets/filter_list_dialog.dart';
import './models/todo.dart';
import 'models/db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => SplashScreen(),
      '/Home': (context) => Home(),
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TodoTask> _todoList = [];
  List<TodoTask> _copyList = [];
  String dropdownValue = 'All';

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    DBService dbService = DBService();
    _todoList = await dbService.getTasks();
    setState(() {
      _copyList = _todoList;
    });
  }

  void _addNewTodo(String details, DateTime selectedDate,
      TimeOfDay selectedTime, String valPriority) async {
    final task = TodoTask(
      id: DateTime.now().toString(),
      todoDetails: details,
      isCompleted: false,
      ondate: selectedDate,
      ontime: selectedTime,
      priority: valPriority,
    );

    DBService dbService = DBService();
    await dbService.add(task);
    loadTasks();

    var scheduledNotificationDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute)
        .subtract(Duration(minutes: 10));
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'todo_id', 'todo and Notification to alert the user about a TODO',
        importance: Importance.high, priority: Priority.high, showWhen: false);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'TODO alert: task is about to expire',
        "$details is scheduled for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedTime.hour}:${selectedTime.minute}",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void _completeTask(TodoTask obj) async {
    var index = _todoList.indexOf(obj);
    final updated = TodoTask(
      id: obj.id,
      todoDetails: obj.todoDetails,
      isCompleted: true,
      ondate: obj.ondate,
      ontime: obj.ontime,
      priority: obj.priority,
    );
    DBService dbService = DBService();
    await dbService.update(updated);

    setState(() {
      _todoList.removeAt(index);
      _todoList.insert(index, updated);
    });
  }

  void _deleteTask(int index) async {
    DBService dbService = DBService();
    await dbService.delete(_todoList[index].id);
    loadTasks();
  }

  void _filterAllTasks() {
    setState(() {
      _todoList.clear();
      _todoList = _copyList;
    });
  }

  void _filterTasksSearch(String query) {
    setState(() {
      _todoList = _copyList
          .where((element) =>
              element.todoDetails.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sortDate() {
    setState(() {
      _todoList.sort((a, b) => a.ondate.compareTo(b.ondate));
    });
  }

  void _sortPriority() {
    setState(() {
      _todoList.sort((a, b) {
        var priorityValues = {'High': 3, 'Medium': 2, 'Low': 1, 'None': 0};
        return priorityValues[b.priority]!
            .compareTo(priorityValues[a.priority]!);
      });
    });
  }

  void _sortAZ() {
    setState(() {
      _todoList.sort((a, b) => a.todoDetails.compareTo(b.todoDetails));
    });
  }

  void _filterDate(DateTime selectedDate) {
    setState(() {
      _todoList = _copyList
          .where((element) =>
              element.ondate.year == selectedDate.year &&
              element.ondate.month == selectedDate.month &&
              element.ondate.day == selectedDate.day)
          .toList();
    });
  }

  void _filterUpcomingTasks() {
    setState(() {
      _todoList = _copyList
          .where((element) => element.ondate.isAfter(DateTime.now()))
          .toList();
    });
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _filterDate(pickedDate);
    });
  }

  void _showTaskAddDialog(BuildContext ctx) {
    print('Show Add Task Dialog');
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddTaskDialog(_addNewTodo),
          );
        });
  }

  void _showFilterDialog(BuildContext ctx) {
    print('Show Filter Dialog');
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: FilterListDialog(
              _sortPriority,
              _sortDate,
              _sortAZ,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: Image.asset('assets/images/logo_app.png'),
      title: const Text('TODO App',
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFFBEEEF7),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.filter_list_alt, color: Colors.black),
          onPressed: () => _showFilterDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_month_sharp, color: Colors.black),
          onPressed: () => _showDatePicker(context),
        ),
      ],
    );
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: TextField(
                onChanged: (value) {
                  _filterTasksSearch(value);
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Search tasks',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter task details to search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            //create dropdown for (all, today, upcoming) is here
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.lightBlue,
                  width: 2.0,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 30,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      if (newValue == 'All') {
                        _filterAllTasks();
                      } else if (newValue == 'Today') {
                        _filterDate(DateTime.now());
                      } else if (newValue == 'Upcoming') {
                        _filterUpcomingTasks();
                      }
                    });
                  },
                  items: <String>['All', 'Today', 'Upcoming']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.55,
              child: TaskList(
                _todoList,
                _completeTask,
                _deleteTask,
              ),
            ),
            SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.1,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showTaskAddDialog(context),
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add, color: Colors.black)),
    );
  }
}

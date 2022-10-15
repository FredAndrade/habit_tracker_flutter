import 'package:flutter/material.dart';
import 'package:habit_tracker/data/database.dart';
import 'package:habit_tracker/widgets/calendary_summary.dart';
import 'package:habit_tracker/widgets/fab_add.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import 'package:habit_tracker/widgets/alert_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  void initState() {

    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }
    else {
      db.loadData();
    }
    db.updateData();

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateData();
  }

  final _newHabitNameController = TextEditingController();
  void createHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialog,
          hintText: 'Digite a ação...',
        );
      },
    );
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();

    db.updateData();
  }

  void cancelDialog() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();

    db.updateData();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialog,
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
      _newHabitNameController.clear();
      Navigator.of(context).pop();

      db.updateData();
    });
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FABAdd(onPressed: createHabit),
        backgroundColor: Colors.white70,
        body: ListView(
          children: [
            CalendarSum(startDate: _myBox.get("START_DATE"), datasets: db.heatMapDataSet,),

            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                },
            )
          ],
        ),
    );
  }
}

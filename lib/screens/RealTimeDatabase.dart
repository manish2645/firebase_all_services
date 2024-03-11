import 'package:flutter/material.dart';

import '../widgets/realtime_database/display_data.dart';
import '../widgets/realtime_database/form.dart';

class RealTimeDatabase extends StatefulWidget {
  const RealTimeDatabase({Key? key}) : super(key: key);

  @override
  State<RealTimeDatabase> createState() => _RealTimeDatabaseState();
}

class _RealTimeDatabaseState extends State<RealTimeDatabase> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          title: const Text("Realtime Database"),
          backgroundColor: const Color(0xFFFF800B),
          bottom: TabBar(
            tabs: [
              Tab(text: "User Form"), // Tab 1 text
              Tab(text: "User Details"), // Tab 2 text
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contents of Tab 1
            Center(
              child: PersonalDetailsForm()
            ),
            // Contents of Tab 2
            Center(
              child: UserListScreen()
            ),
          ],
        ),
      ),
    );
  }
}

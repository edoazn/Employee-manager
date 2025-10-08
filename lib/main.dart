import 'package:employee_app/presentation/pages/add_edit_empoyee_page.dart';
import 'package:employee_app/presentation/pages/employee_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(child: EmployeeApp()));
}

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const EmployeeListPage(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddEditEmployeePage(),
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  AddEditEmployeePage(employeeArg: state.extra),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Employee Management',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
    );
  }
}

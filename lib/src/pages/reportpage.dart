import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/model/employee.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/data/database.dart';
import 'package:tainopersonnel/src/pages/reportlist.dart';
import 'package:tainopersonnel/src/utils/utils.dart';
import 'package:tainopersonnel/src/widget/appbar.dart';
import 'package:tainopersonnel/src/widget/loading.dart';
import 'package:tainopersonnel/src/widget/mytile.dart';
import 'package:tainopersonnel/src/widget/newreport.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/widget/widget.dart';

// ignore: must_be_immutable
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  final pageTitle = "Reports";

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Employee> employees = [];
  bool isLoading = false;
  int page = 0, size = 10;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState state = context.watch<AppState>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pageTitle,
            style: TextStyle(color: theme.primaryColorLight),
          ),
          backgroundColor: theme.primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const BackButtonIcon()),
        ),
        body: FutureBuilder(
            future: operation.getSubordonates(state),
            builder: (context, snapshot) {
              employees = [Employee(id: state.empid, name: 'me')];
              employees.addAll(snapshot.data ?? []);

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              }

              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 60,
                  child: MyTile(
                    textTheme: const TextStyle(fontSize: 20),
                    icon: Logo(
                      content: employees[index].name,
                    ),
                    title: employees[index].name,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportList(
                            empId: employees[index].id,
                            empName: employees[index].name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}

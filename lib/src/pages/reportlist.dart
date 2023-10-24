import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/data/database.dart';

import 'package:tainopersonnel/src/utils/utils.dart' as util;
import 'package:tainopersonnel/src/widget/loading.dart';
import 'package:tainopersonnel/src/widget/newreport.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/widget/widget.dart';

class ReportList extends StatefulWidget {
  final int empId;
  final String empName;
  final int size = 10;

  const ReportList({super.key, required this.empId, required this.empName});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    ScrollPosition p = _scrollController.position;
    if (!p.outOfRange && p.pixels >= p.maxScrollExtent - 10 && !isLoading) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() {
      isLoading = true;
      page++;
    });

    List<Report> items =
        await TainoPersonnelDatabase.getReports(offset: page * widget.size);
    setState(() {
      items.addAll(items);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    late List<Report> reports;
    AppState state = context.watch<AppState>();
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.empName,
            style: TextStyle(color: theme.primaryColorLight),
          ),
          backgroundColor: theme.primaryColor,
          bottom: Tab(
            height: 40,
            child: Text(
              "work reports",
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.primaryColorLight),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const BackButtonIcon(),
          ),
          //bottom: TabBar(),),
        ),
        floatingActionButton: widget.empId == state.empid
            ? FloatingActionButton(
                onPressed: () async {
                  bool? ok = await util.showModal<bool>(
                    context,
                    AddReport(title: 'New Report', action: ReportAction.create),
                  );
                  if (ok != null && ok) {
                    setState(() {
                      reports.add(state.report);
                    });
                    state.report = Report();
                  }
                },
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.add),
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: operation.getDailyReports(
                          widget.size, widget.empId, state),
                      builder: (context, snapshot) {
                        reports = snapshot.data ?? <Report>[];

                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Loading();
                        }

                        return reports.isEmpty
                            ? const Center(
                                child: Text('Nothing to show'),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = reports[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: ReportTile(
                                      item: item,
                                    ),
                                  );
                                },
                              );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

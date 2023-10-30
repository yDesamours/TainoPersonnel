import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';
import 'package:tainopersonnel/src/model/report.dart';
import 'package:tainopersonnel/src/model/state.dart';

import 'package:tainopersonnel/src/utils/utils.dart' as util;
import 'package:tainopersonnel/src/widget/connection_state.dart';
import 'package:tainopersonnel/src/widget/loading.dart';
import 'package:tainopersonnel/src/widget/newreport.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/widget/widget.dart';

class ReportList extends StatefulWidget {
  final int empId;
  final String empName;
  final int size = 10;
  late AppState state;

  ReportList({super.key, required this.empId, required this.empName});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 0;
  List<Report> reports = [];

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
      page = (reports.length / widget.size).ceil();
    });

    List<Report> items = await operation.getDailyReports(widget.state,
        offset: page * widget.size);
    setState(() {
      items.addAll(items);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.state = context.watch<AppState>();
    Language language = context.watch<AppLanguage>().language;
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
              language.workReports,
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
        floatingActionButton: widget.empId == widget.state.empid
            ? FloatingActionButton(
                onPressed: () async {
                  bool? ok = await util.showModal<bool>(
                    context,
                    AddReport(
                        title: language.newReport, action: ReportAction.create),
                  );
                  if (ok != null && ok) {
                    setState(() {
                      reports.add(widget.state.report);
                    });
                    widget.state.report = Report();
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
                child: FutureBuilder(
                  future: operation.getDailyReports(
                    widget.state,
                    offset: reports.length,
                  ),
                  builder: (context, snapshot) {
                    Language language = context.watch<AppLanguage>().language;
                    reports = snapshot.data ?? <Report>[];

                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Loading();
                    }

                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ConnectionStateShower(),
                          reports.isEmpty
                              ? Text(language.emptyList)
                              : Expanded(
                                  child: RefreshIndicator(
                                  onRefresh: () async {
                                    var reportlist =
                                        await operation.getDailyReports(
                                      widget.state,
                                      offset: widget.size,
                                    );

                                    setState(() {
                                      reports = reportlist;
                                    });
                                  },
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: snapshot.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      var item = reports[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: ReportTile(
                                          item: item,
                                          showUpdate: widget.empId ==
                                              widget.state.empid,
                                        ),
                                      );
                                    },
                                  ),
                                ))
                        ]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

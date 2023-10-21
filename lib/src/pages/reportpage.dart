import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/class/report.dart';
import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/data/database.dart';
import 'package:tainopersonnel/src/utils/utils.dart';
import 'package:tainopersonnel/src/widget/newreport.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;
import 'package:tainopersonnel/src/widget/widget.dart';

// ignore: must_be_immutable
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ScrollController _scrollController = ScrollController();

  List<Report> reports = [];
  bool isLoading = false;
  int page = 0, size = 10;

  void _onScroll() {
    ScrollPosition p = _scrollController.position;
    if (!p.outOfRange && p.pixels >= p.maxScrollExtent - 200 && !isLoading) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() {
      isLoading = true;
      page++;
    });

    List<Report> items =
        await TainoPersonnelDatabase.getReports(offset: page * size);
    setState(() {
      items.addAll(items);
      isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppState state = context.watch<AppState>();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My Reports",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    focusElevation: 4,
                    onPressed: () async {
                      bool? ok = await showModal<bool>(
                          context,
                          AddReport(
                              title: 'New Report',
                              action: ReportAction.create));
                      if (ok != null && ok) {
                        setState(() {
                          reports.add(state.report);
                        });
                      }
                    },
                    backgroundColor: theme.primaryColor,
                    child: const Icon(Icons.add),
                  ),
                ),
                FutureBuilder(
                  future: operation.getDailyReports(size, state),
                  builder: (context, snapshot) {
                    reports = snapshot.data ?? <Report>[];

                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Placeholder();
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
    );
  }
}

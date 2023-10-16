import 'package:flutter/material.dart';
import 'package:tainopersonnel/src/data/database.dart';
import 'package:tainopersonnel/src/operation/operation.dart';
import 'package:tainopersonnel/src/widget/newReport.dart';

// ignore: must_be_immutable
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> reports = [];
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

    List<Map<String, dynamic>> items =
        await TainoPersonnelDatabase.getReport(offset: page * size);
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

    return Stack(
      children: [
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              showModal(context, const AddReport());
            },
            backgroundColor: theme.primaryColor,
            child: const Icon(Icons.add),
          ),
        ),
        FutureBuilder(
          future: TainoPersonnelDatabase.getReport(),
          initialData: List.generate(4, (int i) => {"": dynamic}),
          builder: (context, snapshot) {
            reports = snapshot.data ?? [];

            if (snapshot.connectionState != ConnectionState.done) {
              return ListView.builder(
                  itemBuilder: (context, index) => Placeholder());
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
                      var item = reports?[index];
                      return ExpansionTile(
                        title: Text(item?['day'] ?? ''),
                        children: [
                          Text(item?['content']),
                        ],
                      );
                    },
                  );
          },
        )
      ],
    );
  }
}

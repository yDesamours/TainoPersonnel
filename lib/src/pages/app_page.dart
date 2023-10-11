import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tainopersonnel/src/class/state.dart";
import "package:tainopersonnel/src/class/user.dart";

class AppPage extends StatefulWidget {
  const AppPage({super.key});
  @override
  State<StatefulWidget> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  var selectedIndex = 0;
  late Color tileColor;

  List<Widget> pages = [
    Placeholder(color: Colors.white24),
    Placeholder(color: Colors.indigo),
    Placeholder(color: Colors.purple),
    Placeholder(color: Colors.deepPurpleAccent)
  ];

  Color? tileChildColor(int selected) {
    return selected == selectedIndex ? Colors.white : tileColor;
  }

  void setSelected(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    tileColor = theme.primaryColor;

    return Scaffold(
      appBar: MyAppBar(theme: theme),
      drawer: MyDrawer(
          selectedIndex: selectedIndex,
          setSelected: setSelected,
          color: tileChildColor),
      body: pages[selectedIndex],
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;

  const MyAppBar({Key? key, required this.theme}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: theme.primaryColor,
      title: const Image(
        image: AssetImage("tainopersonnel.png"),
        height: 40,
      ),
      actions: [
        PopupMenuButton<AppBarActions>(
          onSelected: (value) async {
            switch (value) {
              case AppBarActions.logout:
                await confirmationRequest(context);
              case AppBarActions.profile:
            }
          },
          child: Image.asset("tainopersonnel.png"),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: AppBarActions.profile,
              child: MyTile(
                title: "Profile",
                theme: theme,
                selected: false,
                color: (int _) => theme.primaryColor,
                index: 0,
                icon: Icons.person,
              ),
            ),
            PopupMenuItem(
              value: AppBarActions.logout,
              child: MyTile(
                title: "Log Out",
                theme: theme,
                selected: false,
                color: (int _) => theme.primaryColor,
                index: 0,
                icon: Icons.logout,
              ),
            )
          ],
        )
      ],
    );
    ;
  }
}

enum AppBarActions { profile, logout }

class MyTile extends StatelessWidget {
  bool selected;
  void Function()? onTap;
  IconData? icon;
  ThemeData? theme;
  TextTheme? textTheme;
  int index;
  String title;
  Color? Function(int) color;

  MyTile({
    super.key,
    required this.selected,
    this.onTap,
    required this.color,
    this.theme,
    required this.index,
    this.title = '',
    this.icon,
  }) : textTheme = theme?.textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        selected: selected,
        onTap: onTap,
        selectedTileColor: theme?.primaryColor,
        title: Text(
          title,
          style: textTheme?.bodySmall,
        ),
        leading: Icon(
          icon,
          color: color(index),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  int selectedIndex;
  void Function(int) setSelected;
  Color? Function(int) color;
  MyDrawer({
    super.key,
    required this.selectedIndex,
    required this.setSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    User? user = context.watch<AppState>().user;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.tenant ?? '',
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      "${user?.firstname} ${user?.lastname}",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              MyTile(
                title: 'Home',
                selected: selectedIndex == 0,
                color: color,
                theme: theme,
                index: 0,
                icon: Icons.home,
                onTap: () {
                  setSelected(0);
                  Navigator.pop(context);
                },
              ),
              MyTile(
                title: "Report",
                selected: selectedIndex == 1,
                color: color,
                theme: theme,
                index: 1,
                icon: Icons.note,
                onTap: () {
                  setSelected(1);
                  Navigator.pop(context);
                },
              ),
              MyTile(
                title: "My time",
                selected: selectedIndex == 2,
                color: color,
                theme: theme,
                index: 2,
                icon: Icons.calendar_month,
                onTap: () {
                  setSelected(2);
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
          const Divider(
            thickness: 2.0,
          ),
          MyTile(
            title: "Settings",
            selected: selectedIndex == 3,
            color: color,
            theme: theme,
            index: 3,
            icon: Icons.settings,
            onTap: () {
              setSelected(3);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

Future<bool> confirmationRequest(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        ThemeData theme = Theme.of(context);
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          alignment: AlignmentDirectional.center,
          title: const Text(
            "Log out?",
            textAlign: TextAlign.center,
          ),
          content: const Text("Are you sure you want to log out",
              textAlign: TextAlign.center, maxLines: 2),
          actions: <ElevatedButton>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(theme.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(theme.secondaryHeaderColor)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}

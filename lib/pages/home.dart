import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_botbar/pages/tab_one.dart';
import 'package:persistent_botbar/pages/tab_two.dart';
import 'package:persistent_botbar/stacked_tabbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CupertinoTabController _tabController;
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
  }

  GlobalKey<NavigatorState> currentNavigatorKey() {
    switch (_tabController.index) {
      case 0:
        return firstTabNavKey;
      case 1:
        return secondTabNavKey;
      default:
        return firstTabNavKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final listOfKeys = [firstTabNavKey, secondTabNavKey];

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return !await currentNavigatorKey().currentState!.maybePop();
        },
        child: CupertinoTabScaffold(
            controller: _tabController,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            tabBar: CustomTabBar(
              height: 60,
              backgroundColor: Colors.transparent,
              currentIndex: currentIndex,
              onTap: (v) {
                if (v == currentIndex && listOfKeys[v].currentState!.canPop()) {
                  currentNavigatorKey()
                      .currentState!
                      .popUntil((route) => route.isFirst);
                }
                currentIndex = v;
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.circle),label: 'Looows'),
                BottomNavigationBarItem(icon: Icon(Icons.circle),label: 'Draft')
              ],
            ),
            tabBuilder: (context, idx) {
              switch (idx) {
                case 0:
                  return CupertinoTabView(
                    navigatorKey: listOfKeys[idx],
                    builder: (ctx) {
                      return const TabOnePage();
                    },
                  );
                case 1:
                  return CupertinoTabView(
                    navigatorKey: listOfKeys[idx],
                    builder: (ctx) {
                      return const TabTwoPage();
                    },
                  );
                default:
                  return const TabOnePage();
              }
            }),
      ),
    );
  }
}

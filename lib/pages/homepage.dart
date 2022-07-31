import 'package:deevskit/pages/dashboard.dart';
import 'package:flutter/material.dart';

import '../widgets/tab_indicator.dart';
import 'apps_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  late TabController tabController;
  late List<NavItem> navItems;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(_controller);
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    navItems = [
      NavItem('Home', Icons.home, const DashboardPage()),
      NavItem('Apps', Icons.apps, const CustomAppsHome()),
    ];

    tabController.addListener(() {
      currentIndex = tabController.index;
      setState(() {});
    });

    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: tabController,
          indicator: const DeevTabIndicator(
              indicatorColor: Colors.deepPurple,
              indicatorStyle: DeevTabIndicatorStyle.circle,
              indicatorHeight: 2,
              radius: 4,
              yOffset: -12,
              width: 20),
          tabs: buildTabs(),
        ),
      ),
      appBar: AppBar(
        title: Text(navItems[currentIndex].title.toString()),
        leading: InkWell(
          child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.menu)),
          onTap: () {
            setState(() {
              if (isCollapsed)
                _controller.forward();
              else
                _controller.reverse();

              isCollapsed = !isCollapsed;
            });
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          menu(context),
          AnimatedPositioned(
            duration: duration,
            top: 0,
            bottom: 0,
            left: isCollapsed ? 0 : 0.6 * screenWidth!,
            right: isCollapsed ? 0 : -0.2 * screenWidth!,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                animationDuration: duration,
                borderRadius: BorderRadius.circular(!isCollapsed ? 20 : 0),
                clipBehavior: Clip.hardEdge,
                elevation: !isCollapsed ? 4 : 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: screenHeight!,
                    child: TabBarView(
                      controller: tabController,
                      children: navItems.map((e) => e.screen).toList(),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildTabs() {
    List<Widget> tabs = [];

    for (int i = 0; i < navItems.length; i++) {
      tabs.add(Container(
          child: Icon(
        navItems[i].icon,
        size: navItems[i].size,
        color: Colors.deepPurple,
      )));
    }
    return tabs;
  }

  menu(BuildContext context) {
    return Container(
      color: Colors.deepPurple.withOpacity(0.4),
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _menuScaleAnimation,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Dashboard",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                  SizedBox(height: 10),
                  Text("Abouts Us",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                  SizedBox(height: 10),
                  Text("Contact Us",
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final double size;

  NavItem(this.title, this.icon, this.screen, [this.size = 28]);
}

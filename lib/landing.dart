import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/rendering.dart';

class LandingPage extends StatefulWidget {
  final String userName;

  const LandingPage({Key key, this.userName}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController;
  MenuPositionController _menuPositionController;
  bool userPageDragging = false;
  final titles = ['Home', 'Call', 'Map', 'Info', 'Profile'];
  final colors = [
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.green,
    Colors.cyan
  ];
  final icons = [
    Icons.home,
    Icons.phone,
    Icons.location_on,
    Icons.info,
    Icons.person
  ];

  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);

    super.initState();
  }

  void handlePageChange() {
    _menuPositionController.absolutePosition = _pageController.page;
  }

  void checkUserDragging(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification &&
        scrollNotification.direction != ScrollDirection.idle) {
      userPageDragging = true;
    } else if (scrollNotification is ScrollEndNotification) {
      userPageDragging = false;
    }
    if (userPageDragging) {
      _menuPositionController.findNearestTarget(_pageController.page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            checkUserDragging(scrollNotification);
          },
          child: PageView(
            controller: _pageController,
            children: [
              _homePage(),
              _callsPage(),
              _mapPage(),
              _infoPage(),
              _profilePage(),
            ],
            onPageChanged: (page) {},
          ),
        ),
        bottomNavigationBar: BubbledNavigationBar(
          controller: _menuPositionController,
          initialIndex: 0,
          itemMargin: EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: Colors.white,
          defaultBubbleColor: Colors.blue,
          onTap: (index) {
            _pageController.animateToPage(index,
                curve: Curves.easeInOutQuad,
                duration: Duration(milliseconds: 500));
          },
          items: titles.map((title) {
            var index = titles.indexOf(title);
            var color = colors[index];
            return BubbledNavigationBarItem(
              icon: getIcon(index, color),
              activeIcon: getIcon(index, Colors.white),
              bubbleColor: color,
              title: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }).toList(),
        ));
  }

  Widget _mapPage() {
    return Container();
  }

  Widget _infoPage() {
    return Container();
  }

  Widget _profilePage() {
    return Container();
  }

  Widget _callsPage() {
    return Container();
  }

  Widget _homePage() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: 128,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8.0,
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sunny Side Up',
                          textScaleFactor: 1.5,
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.yellow,
                          size: 84,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _returnRouteButton(
                Icons.live_help, 'Request for Help', '/request_for_help'),
            _returnRouteButton(Icons.person, 'Missing Person', '/missing'),
            _returnRouteButton(Icons.home, 'Relief Camps', '/relief'),
            _returnRouteButton(Icons.attach_money, 'Contribute', 'contribute'),
            _returnRouteButton(
                Icons.location_on, 'Needs & Collection Centers', 'collections'),
            _returnRouteButton(
                Icons.person, 'Volunteer & NGO Companies', '/volunteer'),
            _returnRouteButton(Icons.map, 'Maps', '/maps'),
            _returnRouteButton(Icons.phone_android, 'Contact Info', '/contact'),
            _returnRouteButton(Icons.list, 'Registered Requests', '/requests'),
            _returnRouteButton(
                Icons.announcement, 'Announcements', '/announcements'),
            _returnRouteButton(Icons.work,
                'Private Relief & Collection Centers', '/privaterelief')
          ],
        ),
      ),
    );
  }

  Widget _returnRouteButton(IconData icon, String title, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ),
    );
  }

  Padding getIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Icon(icons[index], size: 30, color: color),
    );
  }
}

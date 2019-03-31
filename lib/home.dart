import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final drawerHeader = UserAccountsDrawerHeader(
    accountName: Text('Tester McTest'),
    accountEmail: Text('saveprivacy@help.com'),
    currentAccountPicture: CircleAvatar(
      child: FlutterLogo(
        size: 42.0,
      ),
      backgroundColor: Colors.blueGrey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Inflo'),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            drawerHeader,
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            _returnRouteButton(Icons.live_help, 'Request for Help', '/request_for_help'),
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
}

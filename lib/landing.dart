import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:inflo/pages/map_sample.dart';
import 'package:inflo/pages/personal_plan/add_contacts.dart';
import 'package:inflo/profile/profile.dart';
import 'package:inflo/pages/crowdsourcing/crowdsourcing_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inflo/pages/contacts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inflo/pages/personal_plan/personal_plan_dash.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'pages/emergency_message.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingPage extends StatefulWidget {
  final String userName;
  final String uid;
  final List userDoc;
  const LandingPage({Key key, this.userName, this.uid, this.userDoc}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController;
  String userDocumentPath;
  Future userDocument;
  Map documentMap;
  String title;
  Color color;
  LocationData nowLocation;
  MenuPositionController _menuPositionController;
  AppBar appbar = new AppBar();
  double padding;
  bool userPageDragging = false;
  final titles = ['Home', 'Call', 'Map', 'Info', 'Profile'];
  final colors = [
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.teal,
    Colors.cyan
  ];
  final icons = [
    Icons.home,
    Icons.phone,
    Icons.location_on,
    Icons.info,
    Icons.person
  ];
  int _currentPage = 0;
  @override
  void initState() {
    _menuPositionController = MenuPositionController(initPosition: 0);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);
    _pageController.addListener(handlePageChange);
    PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.uid)
        .getDocuments()
        .then((onValue) {
      setState(() {
        padding = MediaQuery.of(context).padding.top;

        userDocumentPath = onValue.documents[0].documentID;
        documentMap =  onValue.documents[0].data ;
        title = 'Inflo';
        color = Colors.red;
      });
    });
    

    initPlatformState();
    super.initState();
  }

  Location _locationService = new Location();
  bool _permission = false;
  String error;

  initPlatformState() async {
    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      //print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        //print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      nowLocation = location;
    });
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
    List<Widget> _children = [
      _homePage(),
      _callsPage(),
      _mapPage(),
      _infoPage(),
      _profilePage(),
    ];

    List<String> titles = [
      'InFlo',
      'Important Numbers',
      'Map',
      'Citizens Floodkit',
      'Profile'
    ];

    return Scaffold(
        floatingActionButton: _currentPage == 1
            ? FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text('ADD'),
                backgroundColor: colors[1],
                onPressed: () async {
                  ContactsService.getContacts(withThumbnails: false)
                      .then((onValue) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddContacts(contacts: onValue,path: userDocumentPath,)));
                  });
                },
              )
            : null,
        appBar: AppBar(
          title: Text(titles.elementAt(_currentPage)),
          backgroundColor: colors.elementAt(_currentPage),
        ),
        body: _children.elementAt(_currentPage),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          items: titles.map((title) {
            var index = titles.indexOf(title);
            var color = colors[index];
            return BottomNavigationBarItem(
              icon: getIcon(index, color),
              title: Text(
                title,
                style: TextStyle(color: color, fontSize: 12),
              ),
            );
          }).toList(),
        ));
  }

  Widget _mapPage() {
    //WARNING MAP
    //From this display users can access a Weather Map where Warning on risk/emergency
    //situations are displayed.
    //The GPS location of user is overlaid on Google Map and other thematic maps by API services.

    return MapSample(
      location: nowLocation,
    );
  }

  Widget _infoPage() {
    return Container(
      child: PersonalPlan(),
    );
  }

  Widget _profilePage() {
    return ProfileScreen(
      userId: widget.uid,
      userDocumentPath: userDocumentPath,
    );
  }

  Widget _callsPage() {

    return Container(
      child: ContactsPage(contacts: documentMap['contacts'],),
    );
  }

  Widget _homePage() {
    //Crowdsourcing Button
    //Personal Floodplan
    //Welcome & Current Weather
    //Emergency Toolkit
    //Emergency Message Tool
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 130,
                        width: 130,
                        child: SvgPicture.asset(
                          'assets/svg/alert.svg',
                        )),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 48,
                          child: FlatButton(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(50.0))),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.message,
                                    color: Colors.white,
                                  ),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                    child: Text(
                                      'EMERGENCY MESSAGE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(color: Colors.white),
                                    ),
                                    flex: 3),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EMessage(
                                            currentLocation: nowLocation,
                                          )));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          width: 220,
                          height: 48,
                          child: FlatButton(
                            color: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(50.0))),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: Colors.white,
                                  ),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                    child: Text(
                                      'VOLUNTEER',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(color: Colors.white),
                                    ),
                                    flex: 3),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EMessage(
                                            currentLocation: nowLocation,
                                          )));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ]),
          ),
          CrowdsourcingDash(uid: widget.uid,userDocRef: userDocumentPath,userDoc: documentMap,)
        ],
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

  Padding getActiveIcon(int index, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Container(
          child: Icon(icons[index], size: 30, color: color),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          )),
    );
  }
}

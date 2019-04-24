//   From this display, the user can access the tools and functionality available under
//   crowdsourcing:
//   •
//   Start Reporting (A)
//   •
//   From where users can register to actively contribute in case of emergency
//   reporting on events, hazards and dangers. [see page 8]
//   •
//   ... on people (B)
//   •
//   From where users can provide information and pictures on people involved
//   in a risk/emergency situation [see page 9]
//   •
//   ... on infrastructures (C)
//   •
//   From where users can provide information on infrastructure and facilities
//   involved in a risk/emergency situation [see page 10]
//   •
//   ... on water level (D)
//   •
//   From where users can provide information and pictures on water height
//   [see page 11]

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inflo/pages/crowdsourcing/damages.dart';
import 'package:inflo/pages/crowdsourcing/exposed_elements.dart';
import 'package:inflo/pages/crowdsourcing/water_level.dart';

class CrowdsourcingDash extends StatelessWidget {
  final String uid;
  final String userDocRef;
  final Map userDoc;

  const CrowdsourcingDash({Key key, this.uid, this.userDocRef, this.userDoc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              CardButton(
                title: 'Participation',
                description:
                    'Register to actively contribute in case of emergency reporting on events, hazards and dangers.',
                assetImage: 'assets/svg/participation.svg',
                route: '/participation',
                userDocRef: userDocRef,
                uid: uid,
                userDoc: userDoc,
              ),
              CardButton(
                title: 'Exposed Elements',
                description:
                    'Provide information and pictures on people involved in a risk/emergency situation ',
                assetImage: 'assets/svg/exposed_elements.svg',
                route: '/exposed_elements',
                userDocRef: userDocRef,
                uid: uid,
                userDoc: userDoc,
              ),
              CardButton(
                title: 'Damages',
                description:
                    'Provide information on infrastructure and facilities involved in a risk/emergency situation',
                assetImage: 'assets/svg/damages.svg',
                route: '/damages',
                userDocRef: userDocRef,
                uid: uid,
                userDoc: userDoc,
              ),
              CardButton(
                title: 'Water Level',
                description: 'Provide information and pictures on water height',
                assetImage: 'assets/svg/raining.svg',
                route: '/water_level',
                userDocRef: userDocRef,
                uid: uid,
                userDoc: userDoc,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final String assetImage;
  final String description;
  final String route;
  final String uid;
  final String userDocRef;
  final Map userDoc;

  const CardButton(
      {Key key,
      this.title,
      this.assetImage,
      this.description,
      this.route,
      this.uid,
      this.userDocRef,
      this.userDoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (route == '/water_level') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WaterLevel(
                          userDocRef: userDocRef,
                          uid: uid,
                          userData: userDoc,
                        )));
          } else if (route == '/exposed_elements') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExposedElements(
                          userDocRef: userDocRef,
                          uid: uid,
                          userData: userDoc,
                        )));
          } else if (route == '/damages') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Damages(
                          userDocRef: userDocRef,
                          uid: uid,
                          userData: userDoc,
                        )));
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                width: 150,
                child: SvgPicture.asset(assetImage),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Divider(),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.body1,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// PERSONAL EMERGENCY PLAN
// From this display users can access:
// • Basic info (A)
// •
//  From where users can store and access contacts of family members
// and of people to be contacted in case of an emergency [see page 14]
// •
//  Useful numbers (B)
// •
//  From where users can store access contacts of key service providers
// in case of an emergency [see page 15]
// •
//  Flood Equipment (C)
// •
//  From where users can access information vital in case of flood. [see
// page 16]
// •
//  Alert levels (D)
// •
//  From where users can access information of preparedness, early
// warning and emergency [see page 17]
// •
//  Awareness (E)
// •
//  From where users can access information on preparedness, early
// warning and emergency measures [see page 18]
// •
//  Insurance cover (F)
// •
//  from where users can store access information on their insurance
// schemes [see page 19]
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonalPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16.0),
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          CardButton(
            title: 'Basic Info',
            description:
                'From where users can store and access contacts of family members and of people to be contacted in case of an emergency',
            assetImage: 'assets/svg/basic_info.svg',
          ),
          CardButton(
            title: 'Flood Equipment',
            description: 'Users can access information vital in case of flood.',
            assetImage: 'assets/svg/flood_equipment.svg',
          ),
          CardButton(
            title: 'Warning Codes',
            description:
                'Users can access information of preparedness, early warning and emergency',
            assetImage: 'assets/svg/warning_codes.svg',
          ),
          CardButton(
            title: 'Awareness',
            description:
                'Users can access information on preparedness, early warning and emergency measures',
            assetImage: 'assets/svg/awareness.svg',
          ),
          CardButton(
            title: 'Insurance Cover',
            description:
                'Users can store access information on their insurance schemes',
            assetImage: 'assets/svg/insurance_cover.svg',
          ),
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final String assetImage;
  final String description;
  final String route;

  const CardButton(
      {Key key, this.title, this.assetImage, this.description, this.route})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: (){},
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

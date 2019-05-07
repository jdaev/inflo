//START REPORTING
//From this display users car register to actively contribute in case of emergency reporting on
//events, hazards and dangers.
//Users have to fill in the form by providing:
//• Name
//• Surname
//• Telephone Number
//In order to register users have to first agree with the Privacy Terms and Conditions to which
//they can access by clicking on the orange link [see page 13].
//
import 'package:flutter/material.dart';

class Participation extends StatelessWidget {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preparedness'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_alert),
            title: Text('Emergency Survival Kit Checklist'),
            subtitle: Text('\nWater:' +
                'Four litres of water/day (bottled water).\n\nTwo litres for drinking and two litres for cooking or washing. Many of us already buy or have a supply of bottled water on hand.  Therefore, always keep enough extra water on hand to last for at least three days.' +
                'Food\n\n' +
                'Non-perishable foods such as canned goods: salmon, tuna, canned vegetables and fruits.  Other food items such as sugar, coffee, tea, honey and high-energy foods like crackers, peanut butter, and food bars (to be consumed and replaced once/year).' +
                'Instant ready-to-eat meals\n\n' +
                'Dried foods\n\n' +
                '' +
                'Equipments:\n\n' +
                'Disposable eating utensils, knives, forks, spoons, cups and plates.\n\n' +
                'Fuel stove and fuel (never use indoors)\n\n' +
                'Waterproof matches and plastic garbage bags\n\n' +
                'Pocket Knife or multi-tool\n\n' +
                'Window covering (plastic sheeting, duct tape)\n\n' +
                '' +
                'Emergency survival kits:\n\n' +
                '' +
                'Flashlight and batteries or crank flashlight. Portable radio and batteries or crank radio. Spare batteries for both\n\n' +
                'First Aid Kit,Extra Car Keys,Cash on hand (including coins for pay phones),Important Personal Papers (ID, personal documents such as passports, birth certificates, social insurance numbers, marriage certificates, etc.)\n\n' +
                'Clothing and Footwear (one extra set),Sturdy shoes,Heavy gloves,Toiletries (toothbrush, toothpaste, toilet paper, tissues, etc.)\n\n' +
                'Whistle (to attract attention)\n\n'),
          ),
          ListTile(
            leading: Icon(Icons.beach_access),
            title: Text('During a Flood'),
            subtitle: Text('\nSeek higher ground.\n\nDo not wait for instructions. \n\nBe aware of flash flood areas such as canals, streams, drainage channels. \n\nBe ready to evacuate.' +
                '\n\nIf instructed, turn off utilities at main switches and unplug appliances - do not touch electrical equipment if wet. \n\nIf you must leave your home, do not walk through moving water.' +
                '\n\nSix inches of moving water can knock you off your feet. Use a stick to test depth.' +
                '\n\nDo not try to drive over a flooded road. If your car stalls, abandon it immediately and seek an alternate route.'),
          ),
          ListTile(
            leading: Icon(Icons.brightness_7),
            title: Text('After a flood'),
            subtitle: Text('\nStay away from flood water - do not attempt to swim, walk or drive through the area' +
                '\n\nBe aware of areas where water has receded. Roadways may have weakened and could collapse.' +
                '\n\nAvoid downed power lines and muddy waters where power lines may have fallen.' +
                '\n\nDo not drink tap water until advised by the Health Unit that the water is safe to drink.' +
                '\n\nOnce flood waters have receded you must not live in your home until the water supply has been declared safe for use, all flood-contaminated rooms have been thoroughly cleaned and disinfected, adequate toilet facilities are available, all electrical appliances and heating/cooling systems have been inspected, food, utensils and dishes have been examined, cleaned or disposed of, and floor drains and sumps have been cleaned and disinfected.'),
          ),
        ],
      ),
    );
  }
}

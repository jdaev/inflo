import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  final List contacts;

  const ContactsPage({Key key, this.contacts}) : super(key: key);

  Widget _buildList(context, index) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contacts[index]['name'],
                        style: Theme.of(context).textTheme.title,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: contacts[index]['phone']
                              .map<Widget>(
                                (i) => Text(
                                      i ?? "",
                                      textAlign: TextAlign.left,
                                    ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () async {},
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (contacts != null) {
      return Container(
        margin: EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: _buildList,
          itemCount: contacts.length,
        ),
      );
    } else {
      return Container();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContacts extends StatefulWidget {
  final Iterable<Contact> contacts;
  final String path;
  const AddContacts({
    Key key,
    this.contacts,
    this.path,
  }) : super(key: key);
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  List<Map> contactsList = [];
  List<Map> selectedContacts = [];
  List<bool> selected = new List<bool>();
  @override
  void initState() {
    for (Contact contact in widget.contacts) {
      contactsList.add({
        'name': contact.displayName,
        'phone': contact.phones.map((i) => i.value).toList()
      });
    }
    super.initState();
  }

  Widget _buildContactListItem(BuildContext context, int index) {
    List phoneList = contactsList[index]['phone'].toList();
    selected.add(false);
    if (phoneList.isNotEmpty) {
      return Container(
        //height: 144,
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(8.0),
          child: Center(
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              onTap: null,
              onLongPress: null,
              title: Text(contactsList[index]['name']),
              subtitle: ItemsTile(contactsList[index]['phone']),
              trailing: Checkbox(
                value: selected[index],
                onChanged: (value) {
                  setState(() {
                    selected[index] = value;
                  });
                  if (selectedContacts.contains(contactsList[index])) {
                    selectedContacts.remove(contactsList[index]);
                  } else {
                    selectedContacts.add(contactsList[index]);
                    print(selectedContacts);
                  }
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contacts'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemBuilder: _buildContactListItem,
        itemCount: contactsList.length,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('DONE'),
              onPressed: () {
                Firestore.instance
                    .collection('users')
                    .document(widget.path)
                    .updateData({'contacts': selectedContacts}).then((value) {
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class ItemsTile extends StatelessWidget {
  final List<String> _items;
  ItemsTile(this._items);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items
          .map(
            (i) => Text(i ?? ""),
          )
          .toList(),
    );
  }
}

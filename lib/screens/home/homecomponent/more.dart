import 'package:flutter/material.dart';

import 'package:sparknp/model/frontjson.dart';

import 'package:sparknp/widgets/appbar/appbar.dart';
import 'package:sparknp/screens/categories/categoriescomponents/itemcard.dart';

class MoreScreen extends StatefulWidget {
  final String name;
  final ApiFront front;

  const MoreScreen({Key key, this.name, this.front}) : super(key: key);
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: ItemCard(
          name: widget.name,
          front: widget.front,
        ));
  }
}
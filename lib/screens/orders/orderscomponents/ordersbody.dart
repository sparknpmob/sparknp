import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:sparknp/router.dart';
import 'package:sparknp/constants.dart';

import 'package:sparknp/model/screenarguments.dart';

class OrdersBody extends StatefulWidget {
  final orders;
  const OrdersBody({Key key, this.orders}) : super(key: key);

  @override
  _OrdersBodyState createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  List _ordersList;

  @override
  void initState() {
    super.initState();
    setState(() {
      _ordersList = widget.orders["orders"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: (_ordersList.length == 0)
            ? Container(
                height: 400,
                child: Center(
                  child: Text(
                    "You don't have any Orders.",
                    style: AppTheme.h1Style,
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  _item(widget.orders),
                ],
              ),
      ),
    );
  }

  Widget _item(var model) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        itemCount: _ordersList.length,
        itemBuilder: (context, index) {
          dynamic order = _ordersList[index];
          var cart = jsonDecode(order['cart']);
          return Container(
            width: size.width * 0.9,
            height: size.height * 0.3,
            child: Column(children: [
              Expanded(
                child: ListTile(
                  title: TitleText(
                    text: "Order ID : ${order['id'].toString()}",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(children: <Widget>[
                    TitleText(
                      text: 'Status: ',
                      color: LightColor.red,
                      fontSize: 14,
                    ),
                    TitleText(
                      text: order['status'].toString(),
                      fontSize: 14,
                    ),
                  ]),
                  trailing: TitleText(
                    text: "Rs. ${order['pay_amount'].toString()}",
                    fontSize: 14,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, orderCartBody,
                        arguments: ScreenArguments(cart: cart));
                  },
                ),
              ),
            ]),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            thickness: 1,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

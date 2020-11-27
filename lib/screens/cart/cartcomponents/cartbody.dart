import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:sparknp/router.dart';

import 'package:sparknp/constants.dart';
import 'package:sparknp/model/cartmodel.dart';
import 'package:sparknp/model/productmodel.dart';
import 'package:sparknp/screens/cart/cartcomponents/title_text.dart';
import 'package:sparknp/services/cartservice.dart';
import 'package:sparknp/services/productservice.dart';

import 'package:sparknp/services/storage.dart';

class CartBody extends StatefulWidget {
  final Cart cart;
  const CartBody({Key key, this.cart}) : super(key: key);

  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  List _cartList;
  bool _loading;

  final SecureStorage secureStorage = SecureStorage();
  String _token;
  List<String> _productName = [];

  ProductDetails _product;

  @override
  void initState() {
    super.initState();
    _loading = true;
    secureStorage.readData('token').then((value) async {
      int n = widget.cart.carts.length;
      for (int i = 1; i <= n; i++) {
        await ProductService.fetch(widget.cart.carts[i - 1].productId)
            .then((value) {
          _product = value;
          _productName.add(_product.product.name);
        });
      }
      setState(() {
        _token = value;
        _cartList = widget.cart.carts;
        _loading = false;
      });
      secureStorage.writeData("totalPrice", widget.cart.totalPrice.toString());
      secureStorage.writeData("quantity", widget.cart.carts.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_loading)
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: AppTheme.padding,
            child: SingleChildScrollView(
              child: (widget.cart.carts.length == 0)
                  ? Container(
                      height: 400,
                      child: Center(
                        child: Text("No Items in Cart"),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        _item(widget.cart),
                        Divider(
                          thickness: 1,
                          height: 70,
                        ),
                        _price(),
                        SizedBox(height: 30),
                        _submitButton(context),
                      ],
                    ),
            ),
          );
  }

  Widget _item(Cart model) {
    return Container(
      width: AppTheme.fullWidth(context) - 20,
      height: AppTheme.fullHeight(context) * 0.55,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        itemCount: _cartList.length,
        itemBuilder: (context, index) {
          dynamic product = _cartList[index];
          return GestureDetector(
            onTap: () {
              Navigator.popAndPushNamed(context, details,
                  arguments: _product.product);
            },
            child: Container(
              width: AppTheme.fullWidth(context),
              height: 100,
              child: Column(children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      "${_productName[index]}             x${product.quantity}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Row(children: <Widget>[
                      TitleText(
                        text: '\Rs ',
                        color: LightColor.red,
                        fontSize: 14,
                      ),
                      TitleText(
                        text: product.price.toString(),
                        fontSize: 14,
                      ),
                    ]),
                    trailing: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: LightColor.orange,
                      onPressed: () {
                        CartService.destroy(_token, product.productId)
                            .then((removed) {
                          _showDialog(context, "Revoved this items")
                              .whenComplete(() {
                            Navigator.popAndPushNamed(context, cart);
                          });
                        });
                      },
                      child: Text(
                        "Remove",
                        style: TextStyle(color: LightColor.background),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    FlatButton(
                      minWidth: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: LightColor.orange,
                      onPressed: () {
                        CartService.remove(_token, product.productId)
                            .then((removed) {
                          _showDialog(context, "One item removed")
                              .whenComplete(() {
                            Navigator.popAndPushNamed(context, cart);
                          });
                        });
                      },
                      child: Text(
                        "-",
                        style: TextStyle(color: LightColor.background),
                      ),
                    ),
                    FlatButton(
                      minWidth: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: LightColor.orange,
                      onPressed: () {
                        CartService.add(_token, product.productId)
                            .then((removed) {
                          _showDialog(context, "One item added")
                              .whenComplete(() {
                            Navigator.popAndPushNamed(context, cart);
                          });
                        });
                      },
                      child: Text(
                        "+",
                        style: TextStyle(color: LightColor.background),
                      ),
                    ),
                  ],
                )
              ]),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            thickness: 1,
            height: 70,
          );
        },
      ),
    );
  }

  Widget _price() {
    return Positioned(
      bottom: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${widget.cart.carts.length} Items',
            style: GoogleFonts.muli(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: LightColor.grey),
            overflow: TextOverflow.fade,
          ),
          Text(
            "Total: Rs ${widget.cart.totalPrice}",
            style: TextStyle(
              fontSize: 18,
            ),
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          if (widget.cart.carts.isNotEmpty) {
            Navigator.pushNamed(context, processCart);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Next',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Future<void> _showDialog(context, txt) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(txt),
      );
    },
  );
}

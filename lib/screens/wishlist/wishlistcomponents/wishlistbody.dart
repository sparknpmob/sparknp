import 'package:flutter/material.dart';
import 'package:sparknp/model/screenarguments.dart';

import 'package:sparknp/router.dart';

import 'package:sparknp/constants.dart';

import 'package:sparknp/services/productservice.dart';
import 'package:sparknp/services/wishlistservice.dart';
import 'package:sparknp/services/cartservice.dart';
import 'package:sparknp/services/storage.dart';

class WishlistBody extends StatefulWidget {
  final front;
  final wishlist;
  final double currency;
  const WishlistBody({Key key, this.wishlist, this.front, this.currency})
      : super(key: key);

  @override
  _WishlistBodyState createState() => _WishlistBodyState();
}

class _WishlistBodyState extends State<WishlistBody> {
  String imgpath = "https://sparknp.com/assets/images/thumbnails/";
  List _wishlistList;
  bool _loading;
  final SecureStorage secureStorage = SecureStorage();
  String _token;
  List<String> _productName = [];
  List _productImage = [];

  var _product;

  @override
  void initState() {
    super.initState();
    _loading = true;
    secureStorage.readData('token').then((value) async {
      for (int i = 1; i <= widget.wishlist.length; i++) {
        await ProductService.fetch(widget.wishlist[i - 1]["product_id"])
            .then((value) {
          _product = value;
          _productImage.add(_product["thumbnail"]);
          _productName.add(_product["name"]);
        });
      }
      setState(() {
        _token = value;
        _wishlistList = widget.wishlist;
        _loading = false;
      });
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
              child: (widget.wishlist.length == 0)
                  ? Container(
                      height: 400,
                      child: Center(
                        child: Text(
                          "No Items in Wishlist",
                          style: AppTheme.h1Style,
                        ),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        _item(),
                      ],
                    ),
            ),
          );
  }

  Widget _item() {
    return Container(
      width: AppTheme.fullWidth(context) - 20,
      height: AppTheme.fullHeight(context) * 0.8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        itemCount: _wishlistList.length,
        itemBuilder: (context, index) {
          dynamic product = _wishlistList[index];
          return Dismissible(
              key: Key(cart),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                WishlistService.remove(_token, product["id"]).then((value) {
                  Navigator.popAndPushNamed(context, bottomnav,
                      arguments: ScreenArguments(
                          front: widget.front,
                          index: 3,
                          currency: widget.currency));
                });
              },
              child: Container(
                height: AppTheme.fullHeight(context) * 0.125,
                child: Column(children: [
                  ListTile(
                    leading: Image.network(
                      imgpath + _productImage[index].toString(),
                      height: AppTheme.fullHeight(context) * 0.125,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      "${_wishlistList[index]["product"]["name"]}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart_rounded),
                        color: Colors.indigo[900],
                        onPressed: () {
                          CartService.add(
                                  _token, _wishlistList[index]["product"]["id"])
                              .then(
                            (added) {
                              _showDialog(context, "Added to Cart");
                            },
                          ).whenComplete(() {
                            WishlistService.remove(_token, product["id"])
                                .then((value) {
                              Navigator.popAndPushNamed(context, bottomnav,
                                  arguments: ScreenArguments(
                                      front: widget.front,
                                      currency: widget.currency,
                                      token: _token,
                                      index: 2));
                            });
                          });
                        }),
                  ),
                ]),
              ));
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

Future<void> _showDialog(context, txt) async {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(txt),
        );
      });
}

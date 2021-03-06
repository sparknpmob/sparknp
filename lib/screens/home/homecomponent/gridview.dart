import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sparknp/router.dart';
import 'package:sparknp/constants.dart';

class GridProduct extends StatefulWidget {
  final String name;
  final String scale;
  final front;
  final double currency;

  const GridProduct({Key key, this.name, this.scale, this.front, this.currency})
      : super(key: key);
  @override
  _GridProductState createState() => _GridProductState();
}

class _GridProductState extends State<GridProduct> {
  String imgpath = "https://sparknp.com/assets/images/thumbnails/";

  String thumbnail;
  List _productList;

  @override
  void initState() {
    super.initState();

    switch (widget.name) {
      case "topProducts":
        return setState(() {
          _productList = widget.front["top_products"];
        });
      case "bestProducts":
        return setState(() {
          _productList = widget.front["best_products"];
        });
      case "bigProducts":
        return setState(() {
          _productList = widget.front["big_products"];
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 4, 0, 4),
        child: Container(
          width: size.width,
          height: size.height * 0.35,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 0),
            itemCount: 6,
            itemBuilder: (context, index) {
              dynamic product = _productList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, details, arguments: product);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 130,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            imgpath + product["thumbnail"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: LightColor.background,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color:
                                    LightColor.primaryColor.withOpacity(0.23),
                              ),
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding / 4,
                                  horizontal: defaultPadding / 4),
                              child: Text(
                                product["name"].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "\Rs ${(product["price"] * widget.currency).toStringAsFixed(0)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: LightColor.textLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

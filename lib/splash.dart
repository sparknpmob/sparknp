import 'package:flutter/material.dart';

import 'package:sparknp/constants.dart';
import 'package:sparknp/screens/account/myaccount.dart';
import 'package:sparknp/screens/categories/categories.dart';

import 'package:sparknp/services/frontservice.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sparknp/screens/cart/cart.dart';
import 'package:sparknp/screens/home/home.dart';
import 'package:sparknp/screens/wishlist/wishlist.dart';

import 'package:sparknp/services/storage.dart';

class SplashScreen extends StatefulWidget {
  final int index;

  const SplashScreen({Key key, this.index}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SecureStorage secureStorage = SecureStorage();

  bool _loading;
  double currency;

  @override
  void initState() {
    super.initState();
    _loading = true;

    FrontService.converter().then((value) {
      setState(() {
        currency = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            color: LightColor.textColor,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : FutureBuilder(
            future: FrontService.fetch(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    color: LightColor.textColor,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  return (snapshot.hasError)
                      ? Scaffold(
                          body: Container(
                            child: Center(
                              child: Text(
                                "Connect To the Internet",
                                style: AppTheme.h1Style,
                              ),
                            ),
                          ),
                        )
                      : Bottomnavbar(front: snapshot.data, currency: currency);
                default:
              }
              Bottomnavbar(front: snapshot.data, currency: currency);
            });
  }
}

class Bottomnavbar extends StatefulWidget {
  final front;
  final String token;
  final int index;
  final currency;
  Bottomnavbar({
    Key key,
    this.front,
    this.token,
    this.index,
    this.currency,
  }) : super(key: key);
  @override
  _BottomnavbarState createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  @override
  void initState() {
    if (widget.index == 2) {
      _currentIndex = 2;
      _pageController = PageController(initialPage: 2, keepPage: false);
    }

    if (widget.index == 3) {
      _currentIndex = 3;
      _pageController = PageController(initialPage: 3, keepPage: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomeScreen(
              front: widget.front,
              token: widget.token,
              currency: widget.currency,
            ),
            Categories(category: widget.front["categories"]),
            CartScreen(
              front: widget.front,
              currency: widget.currency,
            ),
            WishlistScreen(
              front: widget.front,
              currency: widget.currency,
            ),
            AccountScreen()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            activeColor: LightColor.primaryColor,
            inactiveColor: LightColor.darkgrey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.list_alt_rounded),
            title: Text("Categories"),
            activeColor: LightColor.primaryColor,
            inactiveColor: LightColor.darkgrey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            title: Text("Cart"),
            activeColor: LightColor.primaryColor,
            inactiveColor: LightColor.darkgrey,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset("assets/Heart Icon.svg"),
            title: Text("Wishlist"),
            activeColor: LightColor.primaryColor,
            inactiveColor: LightColor.darkgrey,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("My Account"),
            activeColor: LightColor.primaryColor,
            inactiveColor: LightColor.darkgrey,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

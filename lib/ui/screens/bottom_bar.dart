import 'package:flutter/material.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/screens/feeds.dart';
import 'package:user_app/ui/screens/home.dart';
import 'package:user_app/ui/screens/search.dart';
import 'package:user_app/ui/screens/user_info.dart';
import 'package:user_app/ui/screens/wishlist.dart';
import 'package:user_app/ui/widgets/authenticate.dart';

class BottomBarScreen extends StatefulWidget {
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map> _pages;

  late int _selectedIndex;

  void _selectedPages(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {'page': HomeScreen(), 'title': 'Home'},
      {'page': FeedsScreen(), 'title': 'Feeds'},
      {'page': SearchScreen(), 'title': 'Search'},
      {'page': Authenticate(child: WishlistScreen()), 'title': 'Wishlist'},
      {'page': Authenticate(child: UserInfoScreen()), 'title': 'User'},
    ];
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _selectedPages,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Theme.of(context).cardColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(mHomeIcon),
              label: 'Home',
              tooltip: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(mFeedsIcon),
              label: 'Feeds',
              tooltip: 'Feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(null),
              label: 'Search',
              tooltip: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(mWishListIcon),
              label: 'Wishlist',
              tooltip: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(mUserIcon),
              label: 'User',
              tooltip: 'User',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedPages(2);
        },
        child: Icon(mSearchIcon),
        elevation: 2,
        splashColor: Theme.of(context).primaryColor.withAlpha(2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/screens/feeds.dart';
import 'package:user_app/ui/screens/home.dart';
import 'package:user_app/ui/screens/search.dart';
import 'package:user_app/ui/screens/user_info.dart';
import 'package:user_app/ui/screens/wishlist.dart';
import 'package:user_app/ui/widgets/authenticate.dart';

import 'buy_screen/my_orders_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
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
      //{'page': HomeScreen(), 'title': 'Home'},
      {
        'page': const MyOrdersScreen(
          status: 'Pending',
          confirmedDate: '8:30 am,  Nov 12, 2024',
          orderdDate: '8:30 am,  Nov 12, 2024',
        ),
        'title': 'Home'
      },
      {'page': FeedsScreen(), 'title': 'Feeds'},
      {'page': const SearchScreen(), 'title': 'Search'},
      {
        'page': const Authenticate(child: WishlistScreen()),
        'title': 'Wishlist',
      },
      {'page': const Authenticate(child: UserInfoScreen()), 'title': 'User'},
    ];
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _pages[_selectedIndex]['page'],
        bottomNavigationBar: SizedBox(
          height: 11.h,
          child: BottomAppBar(
            elevation: 10,
            notchMargin: 6,
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            child: BottomNavigationBar(
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _selectedPages,
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              backgroundColor: Theme.of(context).cardColor,
              items: const [
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
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selectedPages(2);
          },
          elevation: 2,
          splashColor: Theme.of(context).primaryColor.withAlpha(2),
          child: Icon(
            mSearchIcon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

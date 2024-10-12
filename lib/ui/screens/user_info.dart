import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/assets_path.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/user_model.dart';
 import 'package:user_app/core/providers/theme_change_provider.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final ScrollController _scrollController = ScrollController();
  UserModel _userData = UserModel();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeChange = Provider.of<ThemeChangeProvider>(context);
    final _userDataProvider = Provider.of<UserDataProvider>(context);
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _userDataProvider.fetchUserData();
    });
    _userData = _userDataProvider.userData;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _userData.imageUrl.isNotEmpty && !kIsWeb
                      ? Image.network(
                          _userData.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(ImagePath.profilePlaceholder,
                          fit: BoxFit.cover),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 28.0, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //    User bag section

                      _sectionTitle('User Bag'),
                      Card(
                        child: Column(
                          children: [
                            _userBagListTile(
                                'Wishlist',
                                mWishListIcon,
                                mTrailingIcon,
                                context,
                                () => Navigator.of(context)
                                    .pushNamed(RouteName.wishlistScreen)),
                            _userBagListTile(
                                'Cart',
                                mCartIcon,
                                mTrailingIcon,
                                context,
                                () => Navigator.of(context)
                                    .pushNamed(RouteName.cartScreen)),

                          ],
                        ),
                      ),

                      //    User information section
                      Row(
                        children: [
                          _sectionTitle('User Details'),
                            const Spacer(),
                       
                          FloatingActionButton(
                            mini: true,
                            ///will have to navigate to the update users information page

                            onPressed: () => Navigator.of(context).pushNamed(RouteName.updateUserInfo),
                            heroTag: 'btn1',
                            child: Icon(mEditIcon),
                          )
                        ],
                      ),
                      Card(
                        child: Column(
                          children: [
                            _userInformationListTile(
                                _userData.fullName, mUserIcon, context),

                            _userInformationListTile(
                                 _userData.email, mEmailIcon, context),
                            _userInformationListTile(
                                _userData.phoneNumber, mPhoneIcon, context),
                            _userInformationListTile(
                                _userData.address, mShippingAddress, context),
                            _userInformationListTile(
                                'Joined ${_userData.joinedAt}',
                                mJoinDateIcon,
                                context),
                          ],
                        ),
                      ),

                      //    Settings Section

                      _sectionTitle('Settings'),
                      Card(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Dark Theme'),
                              secondary: _customIcon(Icons.dark_mode),
                              value: _themeChange.isDarkTheme,
                              onChanged: (bool value) {
                                setState(() {
                                  _themeChange.isDarkTheme = value;
                                });
                              },
                            ),
                            ListTile(
                                title: Text('Sign Out'),
                                leading:
                                    _customIcon(Icons.exit_to_app_outlined),
                                onTap: () {
                                  MyAlertDialog.signOut(context);
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Button Appbar to upload profile picture
          _uploadPictureFab(),
        ],
      ),
    );
  }

  Widget _userInformationListTile(title, icon, context) {
    return ListTile(
      title: Text(title),
      leading: _customIcon(icon),
      onTap: () {},
    );
  }

  Widget _userBagListTile(String title, IconData leadingIcon,
      IconData trailingIcon, BuildContext context, Function() onTap) {
    return ListTile(
      title: Text(title, ),
      leading: _customIcon(leadingIcon),
      trailing: _customIcon(trailingIcon),
      onTap: onTap,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 0),
      child: Text(
        title.toUpperCase(),

      ),
    );
  }

  Widget _customIcon(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget _uploadPictureFab() {
    // Starting Fab position
    final double defaultTopMargin = 200.0 - 20;
    // pixels from top where scalling should start
    final double scaleStart = defaultTopMargin / 2;
    // pixels from top where scalling should end
    final double scaleEnd = scaleStart / 2;

    double _top = defaultTopMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      _top -= offset;

      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        // offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        // offset passed scaleEnd => hide Fab
        scale = 0.0;
      }
    }

    return Positioned(
        top: _top,
        right: 16.0,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => MyAlertDialog.imagePicker(context),
            heroTag: 'btn1',
            child: Icon(mCameraIcon),
          ),
        ));
  }
}

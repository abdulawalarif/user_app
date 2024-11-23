import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/constants/assets_path.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/theme_change_provider.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/user_data_provider.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
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
    final themeChange = Provider.of<ThemeChangeProvider>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      userDataProvider.fetchUserData();
    });
    _userData = userDataProvider.userData;

    return SafeArea(
      child: Scaffold(
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
                        ? CachedNetworkImage(
                            imageUrl: _userData.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.asset(
                            ImagePath.profilePlaceholder,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //    User bag section

                        _sectionTitle('User Bag'),
                        Card(
                          child: Column(
                            children: [
                              _userBagListTile(
                                'My Orders',
                                mOrdersListIcon,
                                mTrailingIcon,
                                context,
                                () => Navigator.of(context).pushNamed(
                                    RouteName.myOrdersScreen,
                                    arguments: {
                                      'userId': _userData.id,
                                    }),
                              ),
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
                                    .pushNamed(RouteName.cartScreen),
                              ),
                            ],
                          ),
                        ),

                        //    User information section
                        _sectionTitle('User Details'),
                        Card(
                          child: Column(
                            children: [
                              _userInformationListTile(
                                _userData.fullName,
                                mUserIcon,
                                context,
                              ),
                              _userInformationListTile(
                                _userData.email,
                                mEmailIcon,
                                context,
                              ),
                              _userInformationListTile(
                                _userData.phoneNumber,
                                mPhoneIcon,
                                context,
                              ),
                              _userInformationListTile(
                                _userData.address,
                                mShippingAddress,
                                context,
                              ),
                              _userInformationListTile(
                                'Joined ${_userData.joinedAt}',
                                mJoinDateIcon,
                                context,
                              ),
                            ],
                          ),
                        ),

                        //    Settings Section

                        _sectionTitle('Settings'),

                        ListTile(
                          leading: const Icon(Icons.policy_sharp),
                          title: const Text('Privacy Policies'),
                          onTap: (() async {
                            // var url = 'https://sites.google.com/view/solutionpro';
                            // if(await canLaunch(url)){
                            //   await launch(url);
                            // }
                            // else
                            // {
                            //   throw "Cannot load url";
                            // }
                          }),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: const Text('Terms Of Use'),
                          onTap: (() async {
                            // if(await canLaunch(url)){
                            //   await launch(url);
                            // }
                            // else
                            // {
                            //   throw "Cannot load url";
                            // }
                          }),
                        ),
                        Card(
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text('Dark Theme'),
                                secondary: _customIcon(Icons.dark_mode),
                                value: themeChange.isDarkTheme,
                                onChanged: (bool value) {
                                  setState(() {
                                    themeChange.isDarkTheme = value;
                                  });
                                },
                              ),
                              ListTile(
                                  title: const Text('Sign Out'),
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

  Widget _userBagListTile(
    String title,
    IconData leadingIcon,
    IconData trailingIcon,
    BuildContext context,
    Function() onTap,
  ) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
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
        style: Theme.of(context).textTheme.titleLarge,
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
    const double defaultTopMargin = 200.0 - 20;
    // pixels from top where scalling should start
    const double scaleStart = defaultTopMargin / 2;
    // pixels from top where scalling should end
    const double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;

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
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.of(context).pushNamed(
            RouteName.updateUserInfo,
            arguments: _userData,
          ),
          heroTag: 'btn1',
          child: const Icon(mEditIcon),
        ),
      ),
    );
  }
}

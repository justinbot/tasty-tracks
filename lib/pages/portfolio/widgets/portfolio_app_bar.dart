import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/user_profile_model.dart';
import 'package:tasty_tracks/pages/settings/settings.dart';
import 'package:tasty_tracks/pages/user_profile/user_profile_edit.dart';

enum MenuActions { editProfile, settings }

class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(92.0);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget tabBar = TabBar(
      tabs: [
        Tab(
          text: 'Bets',
        ),
        Tab(
          text: 'Watching',
        ),
        Tab(
          text: 'History',
        ),
      ],
    );

    return ScopedModelDescendant<UserProfileModel>(
      builder: (context, child, userProfileModel) {
        return StreamBuilder(
          stream: userProfileModel.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot userProfile = snapshot.data.documents.first;

              String username = userProfile.data['username'];
              double points = userProfile.data['points'].toDouble();

              NumberFormat numberFormat = NumberFormat.currency(symbol: '');

              return AppBar(
                title: Text(
                  numberFormat.format(points),
                  style: theme.textTheme.headline
                      .copyWith(color: theme.accentColor),
                ),
                actions: [
                  PopupMenuButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            username,
                            style: theme.textTheme.subhead,
                          ),
                          const SizedBox(width: 12.0),
                          Icon(FeatherIcons.user),
                        ],
                      ),
                    ),
                    onSelected: (MenuActions result) {
                      switch (result) {
                        case MenuActions.editProfile:
                          Navigator.of(context)
                              .pushNamed(UserProfileEditPage.routeName);
                          break;
                        case MenuActions.settings:
                          Navigator.of(context)
                              .pushNamed(SettingsPage.routeName);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MenuActions>>[
                          PopupMenuItem<MenuActions>(
                            value: MenuActions.editProfile,
                            child: Text('Edit profile'),
                          ),
                          PopupMenuItem<MenuActions>(
                            value: MenuActions.settings,
                            child: Text('Settings'),
                          ),
                        ],
                  ),
                ],
                bottom: tabBar,
              );
            } else {
              return AppBar(
                title: Text(
                  '...',
                  style: theme.textTheme.headline
                      .copyWith(color: theme.accentColor),
                ),
                actions: [
                  FlatButton.icon(
                    onPressed: null,
                    icon: Icon(FeatherIcons.user),
                    label: Text('...'),
                  ),
                ],
                bottom: tabBar,
              );
            }
          },
        );
      },
    );
  }
}

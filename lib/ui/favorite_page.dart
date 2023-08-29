import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/provider/database_provider.dart';
import 'package:submission_resto/ui/resto_page.dart';
import 'package:submission_resto/widget/list_resto_widget.dart';

class FavoritePage extends StatelessWidget {
  static const String favoriteTitle = 'Favorites';
  static const routeName = '/favorite-page';

  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(favoriteTitle),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.hasData) {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 16,
                );
              },
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 0.0,
                    bottom: index == state.favorites.length - 1 ? 16 : 0,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RestaurantPage.routeName,
                          arguments: state.favorites[index]);
                    },
                    child: ListRestoWidget(
                      restaurants: state.favorites[index],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/common/funs/get_color_scheme.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/provider/search_provider.dart';
import 'package:submission_resto/ui/resto_page.dart';

class SearchAnchors extends StatefulWidget {
  const SearchAnchors({Key? key}) : super(key: key);

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  String? selectedResto;
  List<RestaurantsShort> searchHistory = <RestaurantsShort>[];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map(
      (resto) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(resto.name!),
        trailing: IconButton(
          icon: const Icon(Icons.transit_enterexit),
          onPressed: () {
            controller.text = resto.name!;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
        onTap: () {
          controller.closeView(resto.name!);
          handleSelection(resto);
        },
      ),
    );
  }

  Future<Iterable<Widget>> getResult(
      SearchController controller, BuildContext context) async {
    ColorScheme colorScheme = getCurrentColorScheme(context);
    final textTheme = Theme.of(context).textTheme;

    final String input = controller.value.text;

    String message = '';
    List<RestaurantsShort> suggestResult = [];

    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    try {
      suggestResult = await searchProvider.searchRestaurant(query: input);
    } catch (e) {
      message = searchProvider.message;
    }

    if (searchProvider.state == ResultState.loading) {
      print('isLoading');
      return <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ];
    } else if (searchProvider.state == ResultState.hasData) {
      print('hasData');
      return getSuggestions(suggestResult, controller);
    } else {
      print('isError');
      return <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (searchProvider.state == ResultState.networkError)
                    ? Icon(Icons.network_check)
                    : Icon(Icons.warning),
                Text(
                  message,
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
      ];
    }
  }

  Iterable<Widget> getSuggestions(
      List<RestaurantsShort> suggestResult, SearchController controller) {
    return suggestResult.map(
      (resto) => _itemResult(resto, controller),
    );
  }

  Widget _itemResult(RestaurantsShort resto, SearchController controller) {
    final image = "$baseUrl$imgRestoMedium${resto.pictureId}";

    return ListTile(
      leading: ClipOval(
        child: Image.network(
          image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, _) => const Center(
            child: Icon(Icons.error),
          ),
        ),
      ),
      title: Text(resto.name!),
      trailing: IconButton(
        icon: const Icon(Icons.transit_enterexit),
        onPressed: () {
          controller.text = resto.name!;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
        },
      ),
      onTap: () {
        controller.closeView(resto.name!);
        handleSelection(resto);
      },
    );
  }

  void handleSelection(RestaurantsShort resto) {
    setState(() {
      selectedResto = resto.name;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, resto);
    });
    Navigator.pushNamed(context, RestaurantPage.routeName, arguments: resto.id);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = getCurrentColorScheme(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SearchAnchor.bar(
        barHintText: 'Cari Restoran',
        suggestionsBuilder: (context, controller) {
          if (controller.text.isEmpty) {
            if (searchHistory.isNotEmpty) {
              return getHistoryList(controller);
            }
            return <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.find_in_page_rounded),
                      Text(
                        'Tidak ada riwayat pencarian.',
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              )
            ];
          }
          return getResult(controller, context);
        },
      ),
    );
  }
}

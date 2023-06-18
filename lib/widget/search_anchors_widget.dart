import 'package:flutter/material.dart';
import 'package:submission_resto/common/const_api.dart';
import 'package:submission_resto/data/model/restaurant/restaurant_short_model.dart';
import 'package:submission_resto/ui/resto_page.dart';

class SearchAnchors extends StatefulWidget {
  final List<RestaurantsShort> restaurants;

  const SearchAnchors({required this.restaurants, Key? key}) : super(key: key);

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  String? selectedColor;
  List<RestaurantsShort> searchHistory = <RestaurantsShort>[];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map(
      (color) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(color.name!),
        trailing: IconButton(
          icon: const Icon(Icons.transit_enterexit),
          onPressed: () {
            controller.text = color.name!;
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
        onTap: () {
          controller.closeView(color.name!);
          handleSelection(color);
        },
      ),
    );
  }

  Iterable<Widget> getResult(SearchController controller) {
    final String input = controller.value.text;
    List<RestaurantsShort> suggestResult = [];

    suggestResult = widget.restaurants
        .where((color) =>
            color.name!.toLowerCase().contains(input.toLowerCase()) ||
            color.city!.toLowerCase().contains(input.toLowerCase()) ||
            color.description!.toLowerCase().contains(input.toLowerCase()))
        .toList();

    return suggestResult.length >= 1
        ? getSuggestions(suggestResult, controller)
        : <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: const Center(
                child: Text(
                  'Tidak ada hasil pencarian',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ];
  }

  Iterable<Widget> getSuggestions(
      List<RestaurantsShort> suggestResult, SearchController controller) {
    return suggestResult.map(
      (filteredColor) => _itemResult(filteredColor, controller),
    );
  }

  Widget _itemResult(
      RestaurantsShort filteredColor, SearchController controller) {
    final image = "$baseUrl$imgRestoMedium/${filteredColor.pictureId}";

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
      title: Text(filteredColor.name!),
      trailing: IconButton(
        icon: const Icon(Icons.transit_enterexit),
        onPressed: () {
          controller.text = filteredColor.name!;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
        },
      ),
      onTap: () {
        controller.closeView(filteredColor.name!);
        handleSelection(filteredColor);
      },
    );
  }

  void handleSelection(RestaurantsShort color) {
    setState(() {
      selectedColor = color.name;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, color);
    });
    Navigator.pushNamed(context, RestaurantPage.routeName, arguments: color);
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Center(
                  child: Text(
                    'Tidak ada riwayat pencarian',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ];
          }
          return getResult(controller);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapsee/pages/place_info_page.dart';
import 'package:mapsee/services/search/searchFilterBloc.dart';
import 'package:mapsee/services/search/searchFilterEvent.dart';
import 'package:mapsee/services/search/searchFilterState.dart';

class SearchFilterPage extends StatelessWidget {
  const SearchFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchTextController = TextEditingController();

    String removeHtmlTags(String input) {
      final regex = RegExp(r'<[^>]*>');
      return input.replaceAll(regex, '');
    }

    return BlocProvider(
      create: (_) => SearchFilterBloc(true),
      child: BlocBuilder<SearchFilterBloc, SearchFilterState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: TextFormField(
                        controller: searchTextController,
                        onChanged: (value) => context
                            .read<SearchFilterBloc>()
                            .add(SearchFilterTimerEvent(query: value)),
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.background,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          hintText: "장소, 버스, 지하철, 주소 등을 입력하세요.",
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              'assets/images/png/cancel.png',
                              width: 20,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            onPressed: () {
                              searchTextController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state is SearchFilterSearchingState ||
                      state is SearchFilterSearchedState) ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.filterings!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 4, left: 12, right: 12),
                            child: InkWell(
                              onTap: () {
                                final selectedItem = state.filterings![index];
                                final data = selectedItem[0]['data'];

                                final title =
                                    removeHtmlTags(data['title'] ?? '');
                                final link = data['link']?.toString() ?? '';
                                final category =
                                    data['category']?.toString() ?? '';
                                final roadAddress =
                                    data['roadAddress']?.toString() ?? '';
                                final address =
                                    data['address']?.toString() ?? '';
                                final telephone =
                                    data['telephone']?.toString() ?? '';

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaceInfoPage(
                                      title: title,
                                      category: category,
                                      roadAddress: roadAddress,
                                      address: address,
                                      link: link,
                                      telephone: telephone,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      removeHtmlTags(state.filterings![index]
                                          .map((item) => item['title'])
                                          .join(' ')),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

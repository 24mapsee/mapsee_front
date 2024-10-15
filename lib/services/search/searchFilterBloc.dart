import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapsee/services/search/searchFilterEvent.dart';
import 'package:mapsee/services/search/searchFilterState.dart';
import 'package:mapsee/services/search/searchRepository.dart';


class SearchFilterBloc extends Bloc<SearchFilterEvent, SearchFilterState> {
  final bool isFilter;
  SearchFilterBloc(this.isFilter) : super(SearchFilterInitState()) {
    on<SearchFilterSearchingEvent>(_searching);
    on<SearchFilterTimerEvent>(_timer);
  }

  Future<void> _timer(
      SearchFilterTimerEvent event, Emitter<SearchFilterState> emit) async {
    if (state.timer != null) {
      state.timer?.cancel();
    }
    Timer? _timer;
    _timer = Timer(const Duration(milliseconds: 1000), () {
      state.timer?.cancel();
      add(SearchFilterSearchingEvent(query: event.query));
    });
    emit(SearchFilterSearchingState(
        timer: _timer, strings: const [], filterings: const []));
  }

  Future<void> _searching(
      SearchFilterSearchingEvent event, Emitter<SearchFilterState> emit) async {
    List<Map<String, dynamic>> _result =
    await SearchRepository.instance.getNaverBlogSearch(query: event.query);

    if (isFilter) {
      List<List<Map<String, dynamic>>> _filteredResults =
      _filtering(data: _result, query: event.query);
      emit(SearchFilterSearchedState(query: event.query, filterings: _filteredResults));
    } else {

      List<String> _titles = _result.map((item) => item['title'] as String).toList();
      List<List<String>> _strings =
      _allMatching(strings: _titles, query: event.query);
      emit(SearchFilterSearchedState(strings: _strings, query: event.query));
    }
  }

  List<List<Map<String, dynamic>>> _filtering({
    required String query,
    required List<Map<String, dynamic>> data,
  }) {
    List<List<Map<String, dynamic>>> _result = [];

    for (var item in data) {
      String title = item['title'] as String;

      List<Map<String, dynamic>> _toMap = [];

      if (title.toLowerCase().contains(query.toLowerCase())) {
        _toMap.add({
          'title': title,
          'highlight': 1,
          'data': item
        });
      } else {
        _toMap.add({
          'title': title,
          'highlight': 0,
          'data': item
        });
      }

      _result.add(_toMap);
    }

    return _result;
  }


  List<List<String>> _allMatching({
    required List<String> strings,
    required String query,
  }) {
    List<List<String>> _result = [];
    if (strings.isNotEmpty) {
      for (int i = 0; i < strings.length; i++) {
        _result.add(strings[i].split(""));
      }
    }
    return _result;
  }

  @override
  void onChange(Change<SearchFilterState> change) {
    super.onChange(change);
  }

  @override
  Future<void> close() {
    state.timer?.cancel();
    return super.close();
  }
}

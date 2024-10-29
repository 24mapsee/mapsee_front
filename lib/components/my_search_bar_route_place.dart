import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapsee/components/my_textfield.dart';
import 'package:mapsee/services/search/searchRepository.dart';
import 'package:mapsee/utils/common.dart';

class MySearchBarRoutePlace extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(Map<String, dynamic>) onItemSelected;

  const MySearchBarRoutePlace(
      {super.key,
      required this.controller,
      required this.onItemSelected,
      required this.hintText});

  @override
  State<MySearchBarRoutePlace> createState() => _MySearchBarRoutePlaceState();
}

class _MySearchBarRoutePlaceState extends State<MySearchBarRoutePlace> {
  // 검색바 컨트롤러
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller;
  }

  // 전체 화면 뷰로 전환 함수
  void _navigateToFullScreenSearch(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenSearch(
          onItemSelected: widget.onItemSelected,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _textController.text = removeHtmlTags(result["title"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToFullScreenSearch(context),
      child: AbsorbPointer(
        child: MyTextfield(
          controller: _textController,
          hintText: widget.hintText,
          obscureText: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

// 전체화면 검색 위젯
class FullScreenSearch extends StatefulWidget {
  final Function(Map<String, dynamic>) onItemSelected;

  const FullScreenSearch({super.key, required this.onItemSelected});

  @override
  State<FullScreenSearch> createState() => _FullScreenSearchState();
}

class _FullScreenSearchState extends State<FullScreenSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // 일정 시간이 지난 후에 검색어가 변경되었을 때 검색 시작
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _updateSuggestions(_searchController.text);
    });
  }

  Future<void> _updateSuggestions(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final suggestions =
            await SearchRepository.instance.getNaverPlaceSearch(query: query);
        log('[성공] 검색 API 요청 결과: $suggestions');
        if (mounted) {
          setState(() {
            _suggestions = suggestions;
            _isLoading = false;
          });
        }
      } catch (error) {
        log('[오류] 검색 API 요청 결과: $error');
        if (mounted) {
          setState(() {
            _suggestions = [];
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _suggestions = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '검색어를 입력해주세요',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_suggestions.isEmpty)
            const Expanded(child: Center(child: Text('검색 결과가 없습니다'))),
          if (_suggestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  return ListTile(
                    title: Text(removeHtmlTags(item['title'])),
                    subtitle: Text(item['roadAddress']),
                    onTap: () {
                      Navigator.pop(context, item);
                      widget.onItemSelected(item);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapsee/services/fetchAndParseResults.dart';
import 'package:mapsee/services/search_result.dart';

class SearchPage2 extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final queryController = useTextEditingController();
    final searchResults = useState<List<SearchResult>>([]);

    Future<void> search() async {
      try {
        final results = await fetchAndParseResults(queryController.text);
        searchResults.value = results;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 실패: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('검색 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: queryController,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: search,
                ),
              ),
              onSubmitted: (_) => search(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: searchResults.value.isEmpty
                  ? Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
                itemCount: searchResults.value.length,
                itemBuilder: (context, index) {
                  final result = searchResults.value[index];
                  return ListTile(
                    title: Text(result.title),
                    subtitle: Text(result.description ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

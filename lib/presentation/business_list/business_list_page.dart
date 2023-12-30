import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/state/business_list_notifier.dart';
import '../business_detail/business_detail_page.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItems = ref.watch(businessListNotifierProvider);
    final listItemsNotifier = ref.watch(businessListNotifierProvider.notifier);
    final widget = listItems.when(
        data: (data) {
          debugPrint('$data');
          return Container(
            color: const Color.fromARGB(255, 235, 235, 235),
            child: ListView(
              children: data
                  .map((listItem) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // 角丸の半径を指定
                        side: const BorderSide(
                          color: Color.fromARGB(255, 187, 187, 187), // 枠線の色を指定
                          width: 1.0, // 枠線の幅を指定
                        ),
                      ),
                      elevation: 0,
                      margin:
                          const EdgeInsets.only(right: 17, left: 17, top: 17),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return BusinessDetailWidget(
                                      articleId: listItem.id);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.decelerate; // 遅くなる効果を持つカーブ

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                    milliseconds: 500), // 遷移の時間を調整
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(17),
                            child: Row(children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(15.0), // 角丸の半径を指定
                                child: Image.network(
                                  "${listItem.eyecatching.toString()}?w=240&h=240&fit=crop",
                                  width: 110.0,
                                  height: 110.0,
                                  fit: BoxFit.cover, // 画像をクリップして表示
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  height: 100,
                                  margin: const EdgeInsets.only(
                                      left: 13.0, right: 3), // 上下左右の余白を設定
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${listItem.title}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${listItem.overview}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                        softWrap: true, // テキストを折り返す
                                        maxLines: 4, // 行数を制限（例では最大3行に制限）
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${listItem.publishedAt.toIso8601String()}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ))))
                  .toList(),
            ),
          );
        },
        error: (e, s) {
          debugPrint('$e');
          return Text('エラー：$e');
        },
        loading: () => const Text('準備中...'));
    return Scaffold(
      appBar: null,
      body: Center(child: widget),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 193, 220, 194),
        onPressed: () {
          listItemsNotifier.refresh();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Add this line
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/state/business_list_notifier.dart';
import '../../infrastructure/model/counter/listitem.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

class BusinessDetailWidget extends ConsumerWidget {
  final String articleId;

  BusinessDetailWidget({Key? key, required this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // BusinessListNotifierプロバイダーを取得
    final listItems = ref.watch(businessListNotifierProvider);

    // 記事のロード状態に応じてUIを表示
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      body: Stack(children: [
        listItems.when(
          data: (data) {
            // 指定されたIDに一致する記事を検索
            final ListItem? listItem =
                data.firstWhere((item) => item.id == articleId
                    // orElse: () => null,
                    );
            // 記事が見つかった場合、その内容を表示
            if (listItem != null) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  Stack(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 350.0,
                          color: Colors.white,
                        ),
                      ),
                      FadeInImage.memoryNetwork(
                        placeholder:
                            kTransparentImage, // You need to import this from the flutter package
                        image: "${listItem.eyecatching.toString()}?fit=crop",
                        height: 350.0,
                        fit: BoxFit.cover, // 画像をクリップして表示
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 17, left: 17, top: 30, bottom: 100),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              '${listItem.title}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Html(
                            data: listItem.body,
                            style: {
                              "h2": Style(
                                fontSize: FontSize(22.0),
                                fontWeight: FontWeight.w600,
                                lineHeight: LineHeight(3),
                                color: Color.fromARGB(198, 55, 55, 55),
                              ),
                              "h3": Style(
                                  fontSize: FontSize(17.0),
                                  fontWeight: FontWeight.w600,
                                  lineHeight: LineHeight(1.8),
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              "p": Style(
                                fontSize: FontSize(16.0),
                                lineHeight: LineHeight(1.8),
                              ),
                              "p > a": Style(
                                textDecoration: TextDecoration.none,
                              ),
                            },
                          ),
                        ]),
                  ),
                ],
              ));
            } else {
              return const CircularProgressIndicator();
            }
          },
          loading: () => Text('Error'),
          error: (error, _) => Text('Error: $error'),
        ),
        Positioned(
          top: 55,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromARGB(109, 101, 101, 101),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ]),
    );
  }
}

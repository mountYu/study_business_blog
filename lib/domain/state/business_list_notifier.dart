import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../infrastructure/model/counter/listitem.dart';
import '../../env/env.dart';

part 'business_list_notifier.g.dart';

@riverpod
class BusinessListNotifier extends _$BusinessListNotifier {
  @override
  Future<List<ListItem>> build() async {
    const String apiEndpoint = 'https://7bs3eom8p5.microcms.io/api/v1/article';
    final Uri uri = Uri.parse(apiEndpoint);

    final result = await http.get(uri, headers: {
      "X-MICROCMS-API-KEY": Env.key,
    });
    final List<dynamic> contents = json.decode(result.body)['contents'];
    debugPrint('$contents');
    final resultmap =
        contents.map((content) => ListItem.fromJSON(content)).toList();
    debugPrint('$resultmap');
    return resultmap;
  }

  Future<void> refresh() async {
    state = AsyncValue.data(await build());
  }
}

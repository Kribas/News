import 'dart:convert';

import 'package:todo_app/Model/NewsModel.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=2021-04-28&sortBy=publishedAt&apiKey=da6fee47702e40b3870c86883c80a824'));
      if(response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = jsonDecode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    }catch(Exception) {
      return newsModel;
    }
    return newsModel;
  }
}
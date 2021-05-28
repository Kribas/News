import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Model/NewsModel.dart';
import 'package:todo_app/Services/NewsApi.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  Future<NewsModel> _newsModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _newsModel = NewsApi().getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder<NewsModel>(
          future: _newsModel,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
            default:
            if(snapshot.hasError) {
              return Text('There was an error ${snapshot.error}');
            }
            return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var article = snapshot.data.articles[index];
                  var formattedTime = DateFormat('dd MMM - HH:mm')
                      .format(article.publishedAt);
                  return Container(
                    height: 100,
                    margin: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)
                          ),
                          child: AspectRatio(aspectRatio: 1,
                          child: (article.urlToImage != null) ? Image.network(article.urlToImage) : Image.asset('images/image.png')
                          ),
                        ),
                        SizedBox(width: 16,),
                        Flexible(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formattedTime),
                            Text(
                              article.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              article.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                },
              itemCount: snapshot.data.articles.length,
                );
          }
      }),
    );
  }
}

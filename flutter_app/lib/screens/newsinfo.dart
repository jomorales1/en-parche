import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_app/models/news.dart';

class NewsInfo extends StatefulWidget {
  const NewsInfo({super.key, required this.news});

  final NewsModel news;

  @override
  State<NewsInfo> createState() => _NewsInfoState();
}

class _NewsInfoState extends State<NewsInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('En parche')
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.news.title!,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              widget.news.image_url!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Autor: ${widget.news.author!}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Fecha: ${widget.news.date!}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ciudad: ${widget.news.city!}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Categoria: ${widget.news.category!}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Descripción: ${widget.news.description!}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
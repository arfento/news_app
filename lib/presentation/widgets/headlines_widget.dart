// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_news/domain/entities/news.dart';

class HeadlinesWidget extends StatelessWidget {
  final List<News> news;
  final Size size;
  final Function(News news) onPressed;
  const HeadlinesWidget({
    Key? key,
    required this.news,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final newsSingle = news[index];
        final dateDifference =
            DateTime.now().difference(newsSingle.publishedDate).inHours;
        return Padding(
          padding: EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => onPressed(newsSingle),
            child: SizedBox(
              width: size.width / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: size.height / 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                          image: newsSingle.urlToImage != null
                              ? NetworkImage(newsSingle.urlToImage!)
                              : const AssetImage(
                                      'assets/images/breaking_news.png')
                                  as ImageProvider),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    newsSingle.title,
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${dateDifference.toString()} hours ago",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Source: ${newsSingle.source.name}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_news/core/clippers/oval_bottom_clipper.dart';
import 'package:flutter_news/core/colors.dart';

import 'package:flutter_news/domain/entities/news.dart';

class NewsOfTheDayWidget extends StatelessWidget {
  final News newsOfTheDay;
  final Function(News news) onPressed;
  const NewsOfTheDayWidget({
    Key? key,
    required this.newsOfTheDay,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalBottomClipper(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.multiply),
              fit: BoxFit.cover,
              image: newsOfTheDay.urlToImage != null
                  ? NetworkImage(newsOfTheDay.urlToImage!)
                  : const AssetImage('assets/images/breaking_news.png')
                      as ImageProvider),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.grey.withOpacity(0.5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Text(
                    'News Of The Day',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colours.kTextColorOnDark),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                newsOfTheDay.title,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colours.kTextColorOnDark),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => onPressed(newsOfTheDay),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Learn more',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colours.kTextColorOnDark),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colours.kTextColorOnDark,
                      size: 24,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

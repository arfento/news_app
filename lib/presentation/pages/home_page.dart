import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news/core/news_params.dart';
import 'package:flutter_news/domain/entities/news.dart';
import 'package:flutter_news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:flutter_news/presentation/pages/detail_page.dart';
import 'package:flutter_news/presentation/widgets/category_chips_widget.dart';
import 'package:flutter_news/presentation/widgets/headlines_widget.dart';
import 'package:flutter_news/presentation/widgets/news_of_the_day_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NewsBloc>(context).add(GetNewsEvent(
      parameters: NewsParams(
        country: WidgetsBinding.instance.window.locale.countryCode ?? 'ID',
        category: CategoryType.general.categoryName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is NewsLoaded) {
            final news = state.news.sublist(1);
            final newsOfTheDay = state.news.first;
            return Column(
              children: [
                Container(
                  height: size.height / 2.5,
                  child: Stack(
                    children: [
                      Container(
                        child: NewsOfTheDayWidget(
                          newsOfTheDay: newsOfTheDay,
                          onPressed: (news) {
                            onNewsSelected(news: news, context: context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: size.width,
                      child: Text(
                        'Breaking News',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    )),
                SizedBox(
                  height: 100,
                  child: CategoryChipsWidget(
                    onSelected: (index, selected) {
                      onCategorySelected(index: index, selected: selected);
                    },
                    selectedIndex: _selectedIndex,
                  ),
                ),
                Expanded(
                    child: HeadlinesWidget(
                        news: news,
                        size: size,
                        onPressed: (news) {
                          onNewsSelected(news: news, context: context);
                        })),
              ],
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }

  void onNewsSelected({required News news, required BuildContext context}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(news: news),
        ));
  }

  void onCategorySelected({required int index, required bool selected}) {
    setState(() {
      if (selected) {
        _selectedIndex = index;
        BlocProvider.of<NewsBloc>(context).add(GetNewsEvent(
            parameters: NewsParams(
                country:
                    WidgetsBinding.instance.window.locale.countryCode ?? 'ID',
                category: CategoryType.values[_selectedIndex].categoryName)));
      }
    });
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_news/core/news_params.dart';

class CategoryChipsWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int, bool) onSelected;
  const CategoryChipsWidget({
    Key? key,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ChoiceChip(
          label: Text(CategoryType.values[index].categoryName),
          avatar: Icon(CategoryType.values[index].categoryImage),
          labelStyle: Theme.of(context).textTheme.displayMedium,
          padding: const EdgeInsets.all(16),
          onSelected: (selected) => onSelected(index, selected),
          selected: selectedIndex == index,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(width: 16);
      },
      itemCount: CategoryType.values.length,
    );
  }
}

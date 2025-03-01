import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';

Widget categoryContainer(CategoryEntity category) {
  return Container(
    decoration: BoxDecoration(
      color: category.iconColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(category.icon, color: category.iconColor, size: 32),
        const SizedBox(height: 8),
        AutoSizeText(category.name,
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 12,
            overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

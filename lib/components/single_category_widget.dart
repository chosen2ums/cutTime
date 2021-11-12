import 'package:flutter/material.dart';
import 'package:salon/models/category.dart';

typedef Value = Function(Category);

class SingleCategoryWidget extends StatelessWidget {
  final Category category;
  final Value onTap;
  final bool selected;
  SingleCategoryWidget(this.category, {this.onTap, this.selected, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: InkWell(
        onTap: () => onTap(category),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.only(right: 15, left: 15),
              child: Text(
                category.engName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? Theme.of(context).hintColor : Theme.of(context).hintColor.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

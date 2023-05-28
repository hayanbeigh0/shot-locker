import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class FABBottomBar extends StatelessWidget {
  final List<FABBottomBarItem> items;
  final String centerItemText;
  int currentIndex;
  final double? height;
  final double? iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  FABBottomBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
  }) : super(key: key);

  _updateIndex(int index) {
    onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _items = List.generate(items.length, (int index) {
      return _buildTabItem(
        item: items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    _items.insert(_items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items,
      ),
      color: backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: iconSize!.sp),
            Text(
              centerItemText,
              // style: TextStyle(color: color),
              //  textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final Color _color = currentIndex == index ? selectedColor : color;
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: _color, size: iconSize!.sp),
                Text(
                  item.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _color,
                    fontSize: 12.sp,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FABBottomBarItem {
  FABBottomBarItem({required this.iconData, required this.text});
  IconData iconData;
  String text;
}

import 'package:flutter/material.dart';

import '../tab/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.main),
        _buildItem(TabItem.settings),
      ],
      onTap: (index) => onSelectTab(TabItem.values[index]),
      currentIndex: currentTab.index,
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      icon: Icon(
        TabIcons[tabItem],
        color: _colorMatching(tabItem),
      ),
      label: tabName[tabItem],
    );
  }

  Color _colorMatching(TabItem item) {
    return currentTab == item ? Colors.blue : Colors.grey;
  }
}

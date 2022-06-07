import 'package:flutter/material.dart';

enum TabItem { main, settings }

const Map<TabItem, String> tabName = {
  TabItem.main: 'Главная',
  TabItem.settings: 'Настройки'
};

const Map<TabItem, IconData> TabIcons = {
  TabItem.main: Icons.photo,
  TabItem.settings: Icons.settings
};

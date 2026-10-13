import 'package:flutter/material.dart';

class CategoryHelper {
  static const Map<String, IconData> _iconMap = {
    'makanan': Icons.restaurant_rounded,
    'food': Icons.restaurant_rounded,
    'makan': Icons.restaurant_rounded,
    'transportasi': Icons.directions_car_rounded,
    'transport': Icons.directions_car_rounded,
    'belanja': Icons.shopping_bag_rounded,
    'shopping': Icons.shopping_bag_rounded,
    'hiburan': Icons.movie_rounded,
    'entertainment': Icons.movie_rounded,
    'kesehatan': Icons.local_hospital_rounded,
    'health': Icons.local_hospital_rounded,
    'pendidikan': Icons.school_rounded,
    'education': Icons.school_rounded,
    'gaji': Icons.account_balance_wallet_rounded,
    'salary': Icons.account_balance_wallet_rounded,
    'freelance': Icons.laptop_rounded,
    'investasi': Icons.trending_up_rounded,
    'investment': Icons.trending_up_rounded,
    'tagihan': Icons.receipt_long_rounded,
    'bills': Icons.receipt_long_rounded,
    'listrik': Icons.electric_bolt_rounded,
    'air': Icons.water_drop_rounded,
    'internet': Icons.wifi_rounded,
    'pulsa': Icons.phone_android_rounded,
    'sewa': Icons.home_rounded,
    'rent': Icons.home_rounded,
    'lainnya': Icons.more_horiz_rounded,
    'other': Icons.more_horiz_rounded,
  };

  static const List<Color> _palette = [
    Color(0xFF6750A4),
    Color(0xFF0B57D0),
    Color(0xFF146C2E),
    Color(0xFFB3261E),
    Color(0xFF7D5260),
    Color(0xFF006A6A),
    Color(0xFF8B5000),
    Color(0xFF4A5568),
  ];

  static IconData getIcon(String category) {
    return _iconMap[category.toLowerCase()] ?? Icons.receipt_long_rounded;
  }

  static Color getColor(String category) {
    final hash = category.toLowerCase().hashCode;
    return _palette[hash.abs() % _palette.length];
  }
}

class CategoryModel {
  final String name;
  final String iconPath; // path asset/icon kategori
  final bool isIncome; // true jika kategori untuk pemasukan

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.isIncome,
  });
}

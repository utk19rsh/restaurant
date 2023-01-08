class MenuCategoryItem {
  String name;
  int price;
  bool inStock;

  MenuCategoryItem({
    required this.name,
    required this.price,
    required this.inStock,
  });

  factory MenuCategoryItem.fromJson(dynamic json) {
    return MenuCategoryItem(
      name: json['name'] as String,
      price: json['price'] as int,
      inStock: json['instock'] as bool,
    );
  }
}

class MenuCategory {
  String name;
  List<MenuCategoryItem> items;

  MenuCategory({
    required this.name,
    required this.items,
  });

  factory MenuCategory.fromJson(dynamic json, {required String name}) {
    var temp = json[name] as List;
    List<MenuCategoryItem> items =
        temp.map((e) => MenuCategoryItem.fromJson(e)).toList();
    return MenuCategory(name: name, items: items);
  }
}

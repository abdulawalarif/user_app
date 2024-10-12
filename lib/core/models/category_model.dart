class CategoryModel {
  String title;
  String image;

  CategoryModel({this.title = '', this.image = ''});

  List<CategoryModel> getCategories() {
    return [
      CategoryModel(
          title: 'Phone', image: 'assets/images/categories/phone.png'),
      CategoryModel(
          title: 'Shoes', image: 'assets/images/categories/shoes.png'),
      CategoryModel(
          title: 'Beauty', image: 'assets/images/categories/beauty.png'),
      CategoryModel(title: 'Food', image: 'assets/images/categories/food.png'),
      CategoryModel(
          title: 'Clothes', image: 'assets/images/categories/clothes.png'),
      CategoryModel(
          title: 'Computer', image: 'assets/images/categories/computer.png'),
      CategoryModel(
          title: 'Electronic',
          image: 'assets/images/categories/electronic.png'),
      CategoryModel(
          title: 'Drinks', image: 'assets/images/categories/drinks.png'),
      CategoryModel(
          title: 'Sport', image: 'assets/images/categories/sport.png'),
    ];
  }
}

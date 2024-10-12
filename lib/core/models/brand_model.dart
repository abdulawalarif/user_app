class BrandModel {
  String name;
  String imageUrl;

  BrandModel({this.name = '', this.imageUrl = ''});

  List<BrandModel> getBrands() => [
        BrandModel(
          name: 'CocaCola',
          imageUrl: 'https://i.postimg.cc/bNx6KmYB/coca-cola.jpg',
        ),
        BrandModel(
          name: 'Cadbury',
          imageUrl: 'https://i.postimg.cc/K8Q0Y4M7/cadbury.jpg',
        ),
        BrandModel(
          name: 'Fanta',
          imageUrl: 'https://i.postimg.cc/k54fR9Q0/fanta.jpg',
        ),
        BrandModel(
          name: 'Dasani',
          imageUrl: 'https://i.postimg.cc/XYn239p7/dasani.jpg',
        ),
        BrandModel(
          name: 'Lipton',
          imageUrl: 'https://i.postimg.cc/6qs0PvkK/lipton.jpg',
        ),
        BrandModel(
          name: 'Minute Maid',
          imageUrl: 'https://i.postimg.cc/hjQsMr3M/minute-maid.jpg',
        ),
        BrandModel(
          name: 'Lays',
          imageUrl: 'https://i.postimg.cc/fbr5xF5J/lays.jpg',
        ),
        BrandModel(
          name: 'Oreo',
          imageUrl: 'https://i.postimg.cc/0jpf1Nvw/oreo.jpg',
        ),
      ];
}

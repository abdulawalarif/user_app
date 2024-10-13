class BrandModel {
  String name;
  String imageUrl;

  BrandModel({this.name = '', this.imageUrl = ''});

  List<BrandModel> getBrands() => [
        BrandModel(
          name: 'CocaCola',
          imageUrl: 'https://i.postimg.cc/L8zjCnZf/AR-coca-cola-logo-4x3-02edef9a3b03456b9c8fb5525eea0537.jpg',
        ),
        BrandModel(
          name: 'Cadbury',
          imageUrl: 'https://i.postimg.cc/MTGRp53b/images.png',
        ),
        BrandModel(
          name: 'Fanta',
          imageUrl: 'https://i.postimg.cc/T1zWQ6dC/fanta-logo-3-resized.jpg',
        ),
        BrandModel(
          name: 'Dasani',
          imageUrl: 'https://i.postimg.cc/CxVqqS6K/images-1.png',
        ),
        BrandModel(
          name: 'Lipton',
          imageUrl: 'https://i.postimg.cc/V65r865K/LIPTONtag.png',
        ),
        BrandModel(
          name: 'Minute Maid',
          imageUrl: 'https://i.postimg.cc/YqFn1NMz/jones-knowles-ritchie-grey-vmly-format-webp-width-2880-RD9-Qu2-Rw-Wk9-KTm-NF.webp',
        ),
        BrandModel(
          name: 'Lays',
          imageUrl: 'https://i.postimg.cc/tJx5NyQ4/ar-lays-4x3-9d398de83a9a4ca6859972ff1b24b458.jpg',
        ),
        BrandModel(
          name: 'Oreo',
          imageUrl: 'https://i.postimg.cc/Nj4x4pVm/OREO-VL-Web-Banner-V4.webp',
        ),
      ];
}

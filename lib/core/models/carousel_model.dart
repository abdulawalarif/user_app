class CarouselModel {
  String image;

  CarouselModel({this.image = ''});

  List<CarouselModel> getCarouselImages() {
    return [
      CarouselModel(image: 'assets/images/carousels/carousel_1.png'),
      CarouselModel(image: 'assets/images/carousels/carousel_2.png'),
      CarouselModel(image: 'assets/images/carousels/carousel_3.png'),
      CarouselModel(image: 'assets/images/carousels/carousel_4.png'),
      CarouselModel(image: 'assets/images/carousels/carousel_5.png'),
    ];
  }
}

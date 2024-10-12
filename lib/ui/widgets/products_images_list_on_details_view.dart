import 'package:flutter/material.dart';

const kPrimaryColorProduct = Color(0xFFFF7643);
const defaultDuration = Duration(milliseconds: 250);

class ProductImagesListOnDetailsView extends StatefulWidget {
  ProductImagesListOnDetailsView({
    Key? key,
    required this.product,
  }) : super(key: key);

  var product;

  @override
  _ProductImagesListOnDetailsViewState createState() => _ProductImagesListOnDetailsViewState();
}

class _ProductImagesListOnDetailsViewState extends State<ProductImagesListOnDetailsView> with SingleTickerProviderStateMixin {
  int selectedImage = 0;



  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    )..addListener(() {
      controller.value = animation!.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        SizedBox(
          width: 290,
          child: GestureDetector(
            onDoubleTapDown: (details) => tapDownDetails = details,

            onDoubleTap: (){
              final position = tapDownDetails!.localPosition;

              final double scale = 5;
              final x = -position.dx * (scale - 1);
              final y = -position.dy * (scale - 1);

              final zoomed = Matrix4.identity()
                ..translate(x,y)
                ..scale(scale);
              final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

              animation = Matrix4Tween(
                begin: controller.value,
                end: end,
              ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));
              animationController.forward(from: 0);

            },
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              transformationController: controller,
              panEnabled: true,
              scaleEnabled: false,

              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  // height and width depend on your your requirement.
                  height: 290.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // radius circular depend on your requirement
                    borderRadius: new BorderRadius.all(
                      Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      // image url your network image url
                      image: NetworkImage(
                        widget.product.imageUrls[selectedImage],                  ),
                    ),
                  ),
                ),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(12.0),
                //   child: SizedBox.fromSize(
                //     size: Size.fromRadius(48),
                //     child: Image.network(widget.product.imageUrls[selectedImage]),
                //   ),
                // ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.product.imageUrls.length,
                    (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColorProduct
                  .withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.product.imageUrls[index]),
      ),
    );
  }
}

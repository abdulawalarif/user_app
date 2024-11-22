import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// product images list widget
/// 
// ignore: must_be_immutable
class ProductImagesListWidget extends StatefulWidget {
  final List<String> productImgList;

     ProductImagesListWidget({
    super.key,
    required this.productImgList,
  });
  double height = 330;
  double width = 350;

  @override
  State<ProductImagesListWidget> createState() =>
      _ProductImagesListWidgetState();
}

class _ProductImagesListWidgetState extends State<ProductImagesListWidget>
    with SingleTickerProviderStateMixin {
  int selectedImage = 0;
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    )..addListener(() {
        controller.value = animation!.value;
      });
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    animationController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Displayed image with fixed dimensions
              SizedBox(
                height: widget.height, // Fixed height for the image container
                width: widget.width, // Fixed width for the image container
                child: GestureDetector(
                  onDoubleTapDown: (details) => tapDownDetails = details,
                  onDoubleTap: () {
                    final position = tapDownDetails!.localPosition;
                    const double scale = 5;
                    final x = -position.dx * (scale - 1);
                    final y = -position.dy * (scale - 1);
                    final zoomed = Matrix4.identity()
                      ..translate(x, y)
                      ..scale(scale);
                    final end = controller.value.isIdentity()
                        ? zoomed
                        : Matrix4.identity();
                    animation = Matrix4Tween(
                      begin: controller.value,
                      end: end,
                    ).animate(CurveTween(curve: Curves.easeOut)
                        .animate(animationController));
                    animationController.forward(from: 0);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InteractiveViewer(
                      clipBehavior: Clip.hardEdge,
                      transformationController: controller,
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: CachedNetworkImage(
                        imageUrl: widget.productImgList[selectedImage],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildShimmerEffect(), // Shimmer effect as a placeholder
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Navigate to the previous image
              Positioned(
                left: 1,
                child: IconButton(
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  onPressed: _onRightArrowTap,
                  color: selectedImage == 0 ? Colors.grey : Colors.black,
                ),
              ),
              // Navigate to the next image
              Positioned(
                right: 1,
                child: IconButton(
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  onPressed: _onLeftArrowTap,
                  color: selectedImage == widget.productImgList.length - 1
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: widget.height / 6.6,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                shrinkWrap: true,
                itemCount: widget.productImgList.length,
                itemBuilder: (context, index) {
                  return buildSmallProductPreview(index);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Build small preview for product images
  Widget buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
          controller.value = Matrix4.identity();
        });
        _scrollToSelectedImage();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: widget.height / 6.7,
        width: widget.width / 6.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFFF7643)
                  .withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: widget.productImgList[index],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                _buildShimmerEffect(), // Shimmer effect for the smaller preview images
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle the shimmer effect placeholder
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300],
      ),
    );
  }

  void _onLeftArrowTap() {
    if (selectedImage < widget.productImgList.length - 1) {
      setState(() {
        selectedImage++;
        controller.value = Matrix4.identity();
      });
      _scrollToSelectedImage();
    }
  }

  void _onRightArrowTap() {
    if (selectedImage > 0) {
      setState(() {
        selectedImage--;
        controller.value = Matrix4.identity();
      });
      _scrollToSelectedImage();
    }
  }

  void _scrollToSelectedImage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double singleItemWidth = widget.width / 6.5;
    double offset =
        selectedImage * singleItemWidth - (screenWidth - singleItemWidth) / 2;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:levis_store/utils/colors.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});
  final imageUrl =
      "https://png.pngtree.com/thumb_back/fw800/background/20240327/pngtree-beauty-fashion-model-girl-wearing-sunglass-with-trendy-clothes-image_15696050.jpg";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.23,
      width: size.width,
      color: bannerColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "NEW COLLECTIONS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "20",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -3,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "%",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "OFF",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                            height: 0.6,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.black12,
                  child: const Text(
                    "SHOP NOW",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  "assets/levi's_logo.png",
                  height: size.height * 0.18,
                  width: size.width * 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

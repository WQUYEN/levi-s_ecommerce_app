import 'package:flutter/material.dart';
import 'package:levis_store/utils/validator.dart';

import '../models/product.dart';

class CuratedItems extends StatelessWidget {
  final Product product;
  final Size size;

  const CuratedItems({super.key, required this.product, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Hero(
            tag: product.primaryImage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(product.primaryImage),
                ),
              ),
              height: size.height * 0.23,
              width: size.width * 0.4,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.favorite_border),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          SizedBox(
            width: size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "LEVI'S",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15,
                ),
                Text(
                  "5.0",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                // Text("${product.buyCount}"),
                // SizedBox(
                //   width: size.width * 0.4, // Kích thước bằng chiều rộng của ảnh
                //   child: Text(
                //     product.name,
                //     maxLines: 2, // Hiển thị tối đa 1 dòng
                //     overflow:

                //         TextOverflow.ellipsis, // Thêm dấu "..." nếu text quá dài
                //     style: const TextStyle(
                //       color: Colors.black26,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.4,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14, height: 1.5),
            ),
          ),
          Row(
            children: [
              Text(
                Validator.formatCurrency(product.price),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                Validator.formatCurrency(
                    product.price + 600000), // Cộng giá trị trước khi định dạng
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.5,
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

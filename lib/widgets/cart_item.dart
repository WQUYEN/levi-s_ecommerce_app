import 'package:flutter/material.dart';
import 'package:levis_store/models/cart.dart';

import '../utils/validator.dart';

class CartItem extends StatelessWidget {
  final bool isChecked;
  final Cart? cart;
  final int quantity;
  final Function onTap;
  final Function onTapCheckBox;
  final Function onTapIncrement;
  final Function onTapDecrease;
  final bool isCartPage;

  const CartItem({
    super.key,
    this.cart,
    this.quantity = 0,
    required this.onTap,
    required this.isChecked,
    required this.isCartPage,
    required this.onTapCheckBox,
    required this.onTapIncrement,
    required this.onTapDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            if (isCartPage)
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  if (value != null) {
                    onTapCheckBox.call();
                  }
                },
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                activeColor: Colors.red,
                checkColor: Colors.white,
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: cart?.productPrimaryImage != null
                  ? Image.network(
                      cart!.productPrimaryImage,
                      width: 120,
                      height: 140,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart?.productName ?? "No product name",
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        "Color: ${cart?.selectedColor}",
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Size: ${cart?.selectedSize}",
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (!isCartPage)
                        Text(
                          "Quantity: ${cart?.quantity}",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Đơn giá: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "${Validator.formatCurrency(cart?.productPrice ?? 0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        if (isCartPage)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    onTapDecrease.call();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 10,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "${cart?.quantity}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    onTapIncrement.call();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/order/order_controller.dart';

import '../../utils/validator.dart';

class OrderStatusPage extends StatelessWidget {
  OrderStatusPage({super.key});

  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    orderController.fetchOrdersByCurrentTab();
    return DefaultTabController(
      length: orderController.statuses.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Status'),
          bottom: TabBar(
            onTap: (index) {
              orderController.currentTab.value = index;
              orderController.fetchOrdersByCurrentTab();
            },
            // padding: EdgeInsets.symmetric(horizontal: 15),
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary,
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: Obx(() {
          if (orderController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderController.orders.isEmpty) {
            return const Center(child: Text("No orders in this status."));
          }

          return ListView.builder(
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              final isMore = orderController.isMoreMap[order.id] ?? false;
              print("isMoreMap: ${orderController.isMoreMap}");

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order ID: ${order.id}",
                              style: const TextStyle(fontSize: 16)),
                          Text(order.status,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      ),
                      ListView.builder(
                        itemCount: order.isMore ? order.items.length : 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, itemIndex) {
                          final itemOrder = order.items[itemIndex];
                          orderController.itemId.value = itemOrder['productId'];
                          print('itemId: ${orderController.itemId.value}');
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: itemOrder['productPrimaryImage'] !=
                                              null
                                          ? Image.network(
                                              itemOrder['productPrimaryImage'],
                                              width: 60,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemOrder['productName'] ??
                                                "No product name",
                                            style:
                                                const TextStyle(fontSize: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Color: ${itemOrder['selectedColor']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Size: ${itemOrder['selectedSize']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Số lượng: ${itemOrder['quantity']}",
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              children: [
                                                Text(
                                                  Validator.formatCurrency(
                                                      itemOrder[
                                                              'productPrice'] ??
                                                          0),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    height: 1.5,
                                                    color: Colors.red,
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
                              ],
                            ),
                          );
                        },
                      ),
                      if (order.items.length > 1)
                        IconButton(
                          icon: Icon(
                            isMore ? Icons.expand_less : Icons.expand_more,
                            size: 16,
                          ),
                          onPressed: () {
                            // orderController.toggleIsMore(order.id);
                            orderController.isMore(order);
                          },
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tổng tiền: ${Validator.formatCurrency(order.totalPrice)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (order.status == "completed" ||
                                  order.status == "canceled")
                                ElevatedButton.icon(
                                  onPressed: () {
                                    orderController.onTapBuyBack(
                                        orderController.itemId.value);
                                  },
                                  label: Text(
                                    "Mua lại",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                        fontSize: 12),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              if (order.status != "canceled") ...[
                                const SizedBox(width: 10),
                                order.status == 'pending'
                                    ? ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(Icons.delivery_dining,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                        label: Text(
                                          "Đang giao hàng",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          side: const BorderSide(
                                              color: Colors.red, width: 1.5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: () {},
                                        label: Text(
                                          "Đánh giá",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          side: const BorderSide(
                                              color: Colors.red, width: 1.5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

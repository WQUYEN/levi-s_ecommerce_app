import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:levis_store/pages/address/address_controller.dart';
import 'package:levis_store/routes/routes_name.dart';
import 'package:levis_store/widgets/common_widget.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final AddressController addressController = Get.put(AddressController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController.fetchAddressByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Obx(() {
        if (addressController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: addressController.addressList.length,
            itemBuilder: (context, index) {
              final item = addressController.addressList[index];
              return Dismissible(
                key: Key(item.id.toString()),
                // Khóa duy nhất cho mỗi item
                direction: DismissDirection.endToStart,
                // Vuốt từ phải sang trái
                background: Container(
                  color: Colors.red, // Màu nền khi vuốt
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  // Xử lý hành động xóa
                  addressController.onTapDelete(item.id);
                  Get.snackbar(
                    "Address Deleted",
                    "The address has been successfully removed.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                confirmDismiss: (direction) async {
                  // Hiển thị hộp thoại xác nhận trước khi xóa
                  return await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text(
                            "Are you sure you want to delete this address?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Không xóa
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Xác nhận xóa
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    print("Click item");
                  },
                  child: Column(
                    children: [
                      CommonWidget.addressItem(
                        context: context,
                        address: item,
                        isAddressList: true,
                        isDefault: item.isDefault,
                        onTap: () {
                          addressController.updateDefaultAddress(item.id);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutesName.addAddressPage);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

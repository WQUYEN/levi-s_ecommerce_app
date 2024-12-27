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
              return GestureDetector(
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
                        })
                  ],
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

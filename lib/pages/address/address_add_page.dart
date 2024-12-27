import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vn_provinces/province.dart';

import 'address_controller.dart';

class AddressAddPage extends StatelessWidget {
  const AddressAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy AddressController từ GetX
    final addressController = Get.put(AddressController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add address"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý khi nhấn nút back
            print("Back button pressed");
            addressController.resetInfor();
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Liên hệ",
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Họ và tên",
                  hintText: "Nguyễn Văn A",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onChanged: (value) {
                addressController.updateNameUser(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Phone number",
                hintText: "(+84)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                labelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onChanged: (value) {
                addressController.updatePhoneNumber(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Địa chỉ",
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const SizedBox(
              height: 10,
            ),
            // Dropdown Tỉnh
            Obx(() {
              return DropdownButton<VNProvince>(
                value: addressController.selectedProvince.value,
                hint: const Text("Chọn Tỉnh/Thành phố"),
                isExpanded: true,
                items: addressController.provinces.map((province) {
                  return DropdownMenuItem<VNProvince>(
                    value: province,
                    child: Text(province.name),
                  );
                }).toList(),
                onChanged: (VNProvince? province) {
                  addressController.onProvinceSelected(province);
                },
              );
            }),

            const SizedBox(height: 16),

            // Dropdown Quận
            Obx(() {
              return DropdownButton<VNDistrict>(
                value: addressController.selectedDistrict.value,
                hint: const Text("Chọn Quận/Huyện"),
                isExpanded: true,
                items: addressController.districts.map((district) {
                  return DropdownMenuItem<VNDistrict>(
                    value: district,
                    child: Text(district.name),
                  );
                }).toList(),
                onChanged: (VNDistrict? district) {
                  addressController.onDistrictSelected(district);
                },
              );
            }),

            const SizedBox(height: 16),

            // Dropdown Xã
            Obx(() {
              return DropdownButton<VNWard>(
                value: addressController.selectedWard.value,
                hint: const Text("Chọn Xã/Phường"),
                isExpanded: true,
                items: addressController.wards.map((ward) {
                  return DropdownMenuItem<VNWard>(
                    value: ward,
                    child: Text(ward.name),
                  );
                }).toList(),
                onChanged: (VNWard? ward) {
                  addressController.onWardSelected(ward);
                },
              );
            }),

            const SizedBox(height: 16),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Số nhà, ngõ, đường",
                  hintText: "Số 2, ngõ abc, đường abc",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onChanged: (value) {
                addressController.updateHouseNumber(value);
              },
            ),
            // TextField nhập số nhà, ngõ, cụm
            const SizedBox(height: 32),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 15,
              child: ElevatedButton(
                onPressed: () {
                  final selectedProvince =
                      addressController.selectedProvince.value?.name;
                  final selectedDistrict =
                      addressController.selectedDistrict.value?.name;
                  final selectedWard =
                      addressController.selectedWard.value?.name;
                  final houseNumber = addressController.houseNumber.value;
                  final phoneNumber = addressController.phoneNumber.value;
                  final nameUser = addressController.nameUser.value;

                  // Validate dữ liệu trước khi thêm
                  if (selectedProvince == null || selectedProvince.isEmpty) {
                    Get.snackbar("Error", "Please select a province");
                    return;
                  }

                  if (selectedDistrict == null || selectedDistrict.isEmpty) {
                    Get.snackbar("Error", "Please select a district");
                    return;
                  }

                  if (selectedWard == null || selectedWard.isEmpty) {
                    Get.snackbar("Error", "Please select a ward");
                    return;
                  }

                  if (houseNumber.isEmpty) {
                    Get.snackbar("Error", "Please enter the house number");
                    return;
                  }

                  if (phoneNumber.isEmpty || phoneNumber.length < 10) {
                    Get.snackbar("Error", "Please enter a valid phone number");
                    return;
                  }

                  if (nameUser.isEmpty) {
                    Get.snackbar("Error", "Please enter your name");
                    return;
                  }

                  // Nếu tất cả đều hợp lệ, thêm địa chỉ
                  addressController.onTapAdd(
                      context,
                      selectedProvince,
                      selectedDistrict,
                      selectedWard,
                      houseNumber,
                      phoneNumber,
                      nameUser);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Bo góc 12px
                    ),
                    backgroundColor: Colors.red.withOpacity(0.7)),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

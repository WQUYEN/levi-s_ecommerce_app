import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:levis_store/models/address.dart';
import 'package:levis_store/services/user_info_service.dart';
import 'package:vn_provinces/province.dart';
import 'package:vn_provinces/vn_provinces.dart';

class AddressController extends GetxController {
  final vnProvinces = VNProvinces();
  final userId = UserInfoService().getUid();
  var addressList = <Address>[].obs;

  Rx<VNProvince?> selectedProvince = Rx<VNProvince?>(null);
  Rx<VNDistrict?> selectedDistrict = Rx<VNDistrict?>(null);
  Rx<VNWard?> selectedWard = Rx<VNWard?>(null);
  RxString houseNumber = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString nameUser = ''.obs;
  var isLoading = false.obs;
  var isDefaultAddress = false.obs;

  RxList<VNProvince> provinces = <VNProvince>[].obs;
  RxList<VNDistrict> districts = <VNDistrict>[].obs;
  RxList<VNWard> wards = <VNWard>[].obs;

  @override
  void onInit() {
    super.onInit();
    provinces.value = vnProvinces.allProvince(keyword: null);
  }

  Future<void> fetchAddressByUserId() async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('address')
          .where('userId', isEqualTo: userId)
          .get();

      addressList.value = querySnapshot.docs.map((doc) {
        return Address.fromFirestore(doc);
      }).toList();
    } catch (e) {
      Get.log("$e");
    } finally {
      isLoading.value = false;
    }
  }

  void onProvinceSelected(VNProvince? province) {
    selectedProvince.value = province;
    selectedDistrict.value = null; // Reset quận/huyện khi tỉnh thay đổi
    selectedWard.value = null; // Reset xã/phường khi quận thay đổi

    // Kiểm tra province code và name trước khi gọi
    if (province != null) {
      // Lấy danh sách quận/huyện dựa trên mã tỉnh
      districts.value = vnProvinces.allDistrict(province.code, keyword: null);
    } else {
      districts.value = [];
    }
    wards.value = []; // Reset danh sách xã/phường
  }

  void onDistrictSelected(VNDistrict? district) {
    selectedDistrict.value = district;
    selectedWard.value = null; // Reset xã/phường khi quận thay đổi

    // Cập nhật danh sách xã/phường dựa trên quận đã chọn
    if (district != null) {
      wards.value = vnProvinces.allWard(district.code, keyword: null);
    } else {
      wards.value = [];
    }
  }

  void onWardSelected(VNWard? ward) {
    selectedWard.value = ward;
  }

  void updateHouseNumber(String value) {
    houseNumber.value = value;
  }

  void updateNameUser(String value) {
    nameUser.value = value;
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
  }

  void onTapAdd(BuildContext context, selectedProvinceAdd, selectedDistrictAdd,
      selectedWardAdd, houseNumberAdd, phoneNumberAdd, nameUserAdd) async {
    try {
      isLoading.value = true;

      await FirebaseFirestore.instance.collection("address").add({
        'userId': userId,
        'other': houseNumberAdd,
        'ward': selectedWardAdd,
        'district': selectedDistrictAdd,
        'province': selectedProvinceAdd,
        'phoneNumber': phoneNumberAdd,
        'nameUser': nameUserAdd,
        'isDefault': false,
      });

      resetInfor();
      await fetchAddressByUserId();
      Get.back();
    } catch (e) {
      Get.snackbar(
          "Levi's Store", "Failed to add address. Please try again. $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDefaultAddress(String selectedAddressId) async {
    try {
      isLoading.value = true;

      // Lấy danh sách tất cả các địa chỉ của user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('address')
          .where('userId', isEqualTo: userId)
          .get();

      // Thực hiện cập nhật
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        final isDefault = doc.id == selectedAddressId;
        batch.update(doc.reference, {'isDefault': isDefault});
      }

      await batch.commit();

      // Làm mới danh sách địa chỉ
      await fetchAddressByUserId();
      Get.snackbar("Levi's Store", "Default address updated successfully.");
    } catch (e) {
      Get.snackbar("Levi's Store",
          "Failed to update default address. Please try again. $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetInfor() {
    selectedProvince.value = null;
    selectedDistrict.value = null;
    selectedWard.value = null;
  }
}

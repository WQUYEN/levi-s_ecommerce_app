import 'package:flutter/material.dart';
import 'package:levis_store/models/address.dart';

class CommonWidget {
  static Widget button({
    Function? onTap,
    String? title,
    double? width,
    Color? backGroundBtn,
    Color? borderBtn,
    Color? colorTitle,
    IconData? icon, // Icon có thể null
  }) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 50,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderBtn ?? Colors.black,
          ),
          color: backGroundBtn ?? Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị icon nếu có
            if (icon != null) ...[
              Icon(
                icon, // Sử dụng icon truyền vào
                color: colorTitle ?? Colors.white,
              ),
              const SizedBox(width: 5),
            ],
            // Văn bản tiêu đề
            Text(
              title ?? '',
              style: TextStyle(
                color: colorTitle ?? Colors.white,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget processWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.red,
        backgroundColor: Colors.yellow,
      ),
    );
  }

  static Widget profileBtn(
      {Function? onTap,
      BuildContext? context,
      String? text,
      IconData? iconData,
      bool endIcon = true,
      Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.black.withOpacity(0.1),
      ),
      child: ListTile(
        onTap: () {
          onTap?.call();
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: Icon(
            iconData ?? Icons.add,
            color: Colors.blue,
          ),
        ),
        title: Text(
          text ?? "",
          style: TextStyle(
              color: textColor ?? Theme.of(context!).colorScheme.inversePrimary,
              fontSize: 14),
        ),
        trailing: endIcon
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context!)
                        .colorScheme
                        .primary
                        .withOpacity(0.1)),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,
      ),
    );
  }

  static Widget addressItem(
      {BuildContext? context,
      Address? address,
      bool? isAddressList,
      bool? isDefault,
      Function? onTap}) {
    return Container(
      width: MediaQuery.of(context!).size.width,
      height: MediaQuery.of(context).size.height / 8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isAddressList ?? false)
            Radio<bool>(
              value: true,
              groupValue: isDefault,
              onChanged: (bool? value) {
                if (value == true && onTap != null) {
                  onTap.call();
                }
              },
              activeColor: Colors.red,
              toggleable: true,
            ),
          const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    address!.nameUser,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    " | ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "(+84) ${address.phoneNumber}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                address.other,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontSize: 12),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${address.ward} - ${address.district}",
                    maxLines: 3,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontSize: 12),
                  ),
                  Text(
                    address.province,
                    maxLines: 3,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          if (isAddressList == false)
            const SizedBox(
              width: 30,
            ),
          if (isAddressList == false)
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
        ],
      ),
    );
  }
}

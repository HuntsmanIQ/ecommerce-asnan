import 'package:flutter/material.dart';
import 'package:grostore/custom_ui/boxdecorations.dart';
import 'package:grostore/custom_ui/toast_ui.dart';
import 'package:grostore/models/city_response.dart';
import 'package:provider/provider.dart';
import 'package:grostore/apis/address_api.dart';
import 'package:grostore/models/state_response.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/custom_ui/common_appbar.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/presenters/stock_locations_presenter.dart';

class StockLocations extends StatefulWidget {
  const StockLocations({Key? key}) : super(key: key);

  @override
  _StockLocationsState createState() => _StockLocationsState();
}

class _StockLocationsState extends State<StockLocations> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final presenter =
          Provider.of<StockLocationsPresenter>(context, listen: false);
      presenter.setContext(context);
      presenter.fetchAddresses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Button(
                onPressed: () => showAddAddressDialog(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: ThemeConfig.accentColor,
                minWidth: getWidth(context),
                minHeight: getHeight(context) * 0.1,
                child: const Text('إضـافة مـوقع',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: Consumer<StockLocationsPresenter>(
              builder: (context, data, child) {
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: data.onRefresh,
                  displacement: 0,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: data.addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = data.addresses[index];
                      final isSelected =
                          data.selectedShippingAddress.id == address.id;

                      return Container(
                          decoration:
                              BoxDecorations.shadow(radius: 10).copyWith(
                            border: Border.all(
                              width: 2,
                              color: isSelected
                                  ? ThemeConfig.accentColor
                                  : ThemeConfig.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                print(address.id);
                                print(address.address);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(address.countryName,
                                        style: StyleConfig.fs14fwNormal
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(address.stateName,
                                        style: StyleConfig.fs14fwNormal),
                                    const SizedBox(height: 4),
                                    Text(address.cityName,
                                        style: StyleConfig.fs14fwNormal),
                                    const SizedBox(height: 8),
                                    Text(
                                      address.address,
                                      style: StyleConfig.fs14fwNormal,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  AddressApi.deleteAddress(id: address.id);
                                  data.addresses.removeAt(index);
                                  data.onRefresh();
                                },
                              ),
                            )
                          ]));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return CommonAppbar.show(title: "المواقع", context: context);
  }
}

void showAddAddressDialog(BuildContext context) {
  final TextEditingController addressController = TextEditingController();

  int? selectedGovernorateId;
  int? selectedCityId;
  List<StateInfo> states = [];
  List<CityInfo> cities = [];
  bool isLoadingStates = true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // تحميل المحافظات من API عند فتح الديالوج أول مرة
          if (isLoadingStates) {
            AddressApi.getState(104).then((response) {
              setState(() {
                states = response.object.data;
                if (states.isNotEmpty) {
                  selectedGovernorateId = null;
                }
                isLoadingStates = false;
              });
            });
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'إضافة عنوان جديد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: isLoadingStates
                ? const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<int>(
                          value: selectedGovernorateId,
                          items: states
                              .map((state) => DropdownMenuItem(
                                    value: state.id,
                                    child: Text(
                                      state.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedGovernorateId = value;
                              selectedCityId = null;
                              cities = [];
                            });

                            if (value != null) {
                              var response = await AddressApi.getCity(value);
                              setState(() {
                                cities = response.object.data;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'اختر المحافظة',
                            hintStyle: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade400, width: 1.5),
                            ),
                          ),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[700]),
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          isExpanded: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField<int>(
                          value: selectedCityId,
                          items: cities
                              .map((city) => DropdownMenuItem(
                                    value: city.id,
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo', // خط عربي أنيق
                                        fontSize: 16,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCityId = value;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'اختر المدينة',
                            hintStyle: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade400, width: 1.5),
                            ),
                          ),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[700]),
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          isExpanded: true,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          minLines: 2,
                          maxLines: 3,
                          maxLength: 50,
                          controller: addressController,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'العنوان',
                            labelStyle: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            hintText: 'أدخل عنوانك بالتفصيل',
                            hintStyle: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 15,
                              color: Colors.grey[500],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade400, width: 1.5),
                            ),
                            prefixIcon: Icon(Icons.location_on_outlined,
                                color: Colors.grey[600]),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedGovernorateId == null ||
                      selectedCityId == null ||
                      addressController.text.isEmpty) {
                    ToastUi.show(context, 'الرجاء ملئ جميع الحقول');
                    return;
                  }
                  await AddressApi.addAddress(
                    countryId: 104,
                    stateId: selectedGovernorateId!,
                    cityId: selectedCityId!, // ممكن تعدلها حسب اختيار المستخدم
                    isDefault: 0,
                    address: addressController.text,
                  );

                  // تحديث العناوين في Presenter
                  await Provider.of<StockLocationsPresenter>(context,
                          listen: false)
                      .fetchAddresses(context);

                  Navigator.pop(context);
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      );
    },
  );
}

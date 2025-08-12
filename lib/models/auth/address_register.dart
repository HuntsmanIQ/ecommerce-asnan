import 'package:flutter/material.dart';
import 'package:grostore/apis/address_api.dart';
import 'package:grostore/custom_ui/toast_ui.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/models/city_response.dart';
import 'package:grostore/models/state_response.dart';
import 'package:grostore/screens/main.dart';

class AddressRegister extends StatefulWidget {
  AddressRegister({super.key});

  @override
  _AddressRegisterState createState() => _AddressRegisterState();
}

class _AddressRegisterState extends State<AddressRegister> {
  @override
  void initState() {
    AddressApi.getState(104).then((response) {
      setState(() {
        states = response.object.data;
        if (states.isNotEmpty) {
          selectedGovernorateId = null;
        }
      });
    });

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();

  int? selectedGovernorateId;
  int? selectedCityId;
  List<StateInfo> states = [];
  List<CityInfo> cities = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'إضـافة موقع',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
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
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 1.5),
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
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 1.5),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال العنوان';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedGovernorateId != null &&
                          selectedCityId != null) {
                        try {
                          AddressApi.addAddress(
                            countryId: 104,
                            stateId: selectedGovernorateId!,
                            cityId: selectedCityId!,
                            isDefault: 1,
                            address: addressController.text,
                          );
                          MakeRoute.goAndRemoveAll(context, const Main());
                        } catch (e) {
                          ToastUi.show(context, e);
                        }
                      } else {
                        ToastUi.show(context, 'الرجاء ملئ جميع الحقول');
                      }
                    },
                    child: const Text(
                      'إرسال',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

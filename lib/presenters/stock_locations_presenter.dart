import 'package:flutter/cupertino.dart';
import 'package:grostore/apis/locations_api.dart';
import 'package:grostore/apis/user_api.dart';
import 'package:grostore/helpers/shared_value_helper.dart';
import 'package:grostore/models/locations_response.dart';
import 'package:grostore/models/user/addresses_response.dart';

class StockLocationsPresenter extends ChangeNotifier {
  static BuildContext? context;
  setContext(BuildContext context) {
    StockLocationsPresenter.context = context;
  }

  //
  AddressInfo selectedShippingAddress = AddressInfo(
      id: 0,
      userId: 0,
      countryId: 0,
      countryName: "",
      stateId: 0,
      stateName: "",
      cityId: 0,
      cityName: "",
      address: "",
      isDefault: 0);
  List<AddressInfo> addresses = [];

  fetchAddresses(BuildContext context) async {
    var res = await UserApi.getAddresses();
    addresses.clear();
    addresses.addAll(res.data);
    notifyListeners();
    
  }

  //
  List<LocationInfo> locations = [];
  bool isLocationInit = false;
  int selectedIndex = 0;

  fetchLocations(BuildContext context) async {
    locations = [];
    var res = await LocationApi.getLocations(context);
    locations.addAll(res.object.data);
    isLocationInit = true;
    await stock_location_id.load();
    if (stock_location_id.$.isEmpty) {
      for (var element in locations) {
        if (element.isDefault) {
          stock_location_id.$ = element.id.toString();
        }
      }
    }

    notifyListeners();
  }

  onchange(id) {
    stock_location_id.$ = id.toString();
    notifyListeners();
  }

  cleanAll() {
    locations = [];
    isLocationInit = false;
  }

  initState() {
    cleanAll();
    fetchLocations(context!);
  }

  Future<void> onRefresh() {
    cleanAll();
    fetchLocations(context!);
    return Future.delayed(Duration.zero);
  }
}

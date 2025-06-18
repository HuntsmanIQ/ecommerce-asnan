import 'package:grostore/apis/product_api.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/custom_classes/product_variation_data.dart';
import 'package:grostore/custom_classes/system_data.dart';
import 'package:grostore/custom_ui/toast_ui.dart';
import 'package:grostore/models/product_details_response.dart';
import 'package:grostore/models/product_mini_response.dart';
import 'package:grostore/presenters/wishlist_presenter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductDetailsPresenter extends ChangeNotifier {
  static BuildContext? context;

  setContext(BuildContext context) {
    ProductDetailsPresenter.context = context;
  }

  String slug = "";
  int currentSlider = 0, quantity = 1;
  Variation? selectedVariation;


  // ScrollController mainScrollController = ScrollController();
  ProductDetailsInfo? productInfo;
  List<ProductMini> relatedProducts = [];
  List<ProductVariationData> variations = [];

  bool isProductInfoInitial = false;
  bool isRelatedInitial = false;

  fetchAll(String slug) {
    this.slug = slug;
    reset();
    fetchProductInfo(slug);
    fetchRelatedProduct(slug);
  }

  onChangeBannerIndex(index) {
    currentSlider = index;
    notifyListeners();
  }

  incrementQty() {
    if (selectedVariation != null && selectedVariation!.sock > quantity) {
      quantity++;
      notifyListeners();
    }else{
      ToastUi.show(context!, AppLang.local(context!).product_stock_not_available);
    }

  }

  decrementQty() {
    if (1 < quantity) {
      quantity--;
      notifyListeners();
    }
  }

  fetchProductInfo(String slug) async {
    var response = await ProductApi.details(context!, slug);
    if(response.statusCode==200){
      productInfo = response.object.data;
      if(SystemData.isLogIn) {
        Provider.of<WishlistPresenter>(context!,listen: false).checkWishlist(productInfo!.id);

      }
      isProductInfoInitial = true;
      selectedVariation = productInfo!.variations.first;
      for (var element in productInfo!.variationMaterials) {
        List<ProductVariationValue> value = [];
        for (var valueElement in element.values) {
          String code;
          if (valueElement.code != null) {
            code =
                "0xFF${valueElement.code!.replaceAll("#", "").toUpperCase()}";
          }
          value.add(ProductVariationValue(
              id: valueElement.id,
              isChosen: false,
              name: valueElement.name,
              code: code));
        }
        if (value.isNotEmpty) {
          value.first.isChosen = true;
        }
        variations.add(ProductVariationData(
            id: element.id, name: element.name, values: value));
      }
      notifyListeners();
    }else{
      _toastMessage();
    }
  }

  _toastMessage(){
    ToastUi.show(context!, AppLang.local(context!).something_went_wrong);
  }

  onChangeVariation(int variationIndex, int valueIndex) {
    int previousIndex = variations[variationIndex]
        .values
        .indexWhere((element) => element.isChosen);
    variations[variationIndex].values[previousIndex].isChosen = false;
    variations[variationIndex].values[valueIndex].isChosen = true;
    var variationKey = "";
    for (var element in variations) {
      for (var variationValue in element.values) {
        if (variationValue.isChosen) {
          variationKey += "${element.id}:${variationValue.id}/";
        }
      }
    }

    selectedVariation = productInfo!.variations
        .firstWhere((element) => element.variationKey == variationKey);
    notifyListeners();
  }

  fetchRelatedProduct(slug) async {
    var response = await ProductApi.relatedProducts(context!, slug);
    if(response.statusCode==200){
      relatedProducts.addAll(response.object.data);
      isRelatedInitial = true;
      notifyListeners();
    }else{
      _toastMessage();
    }
  }

  fetBestSellingProducts() async {
    notifyListeners();
  }

  reset() {
    currentSlider = 0;
    quantity = 1;
    // ScrollController mainScrollController = ScrollController();
    productInfo = null;
    relatedProducts = [];
    variations = [];

    isProductInfoInitial = false;
    isRelatedInitial = false;

    notifyListeners();
  }

  Future<void> onRefresh() async {
    reset();
  return  fetchAll(slug);
  }

  changeCurrentSlider(index) {
    currentSlider = index;
    notifyListeners();
  }

  iniState(slug) {
    reset();
    fetchAll(slug);
  }

}

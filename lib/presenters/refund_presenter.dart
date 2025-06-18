import 'package:flutter/material.dart';
import 'package:grostore/apis/refund_api.dart';
import 'package:grostore/custom_ui/loading.dart';
import 'package:grostore/custom_ui/toast_ui.dart';
import 'package:grostore/models/refund_response.dart';

class RefundPresenter extends ChangeNotifier {
  static BuildContext? context;

  setContext(BuildContext context) {
    RefundPresenter.context = context;
  }

  bool isRefundInit = false;
  List<RefundInfo> refundHistory = [];
  int page = 1;


  getRefundHistory() async {
    var response = await RefundApi.getRefundHistory(page);
    if (response.statusCode == 200) {
      refundHistory.addAll(response.object.data);
      page++;
      isRefundInit = true;
      notifyListeners();
    }
  }
 Future<bool> refundReq(BuildContext context,id,reason) async {
    Loading.show(context);
    var response = await RefundApi.refundRequest(id,reason);
    Loading.close();
    ToastUi.show(context, response.object.message);
    return response.object.result;
  }

  fetchAll() async {
    getRefundHistory();
  }

  Future<void>onRefresh() {
    clearAll();
    return fetchAll();
  }

  clearAll() {
    page = 1;
    refundHistory.clear();
    isRefundInit = false;
    notifyListeners();
  }

  initState() {
    clearAll();
    fetchAll();
  }
}

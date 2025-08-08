import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grostore/presenters/help_center_presenter.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditions extends StatelessWidget {
  final List<Map<String, dynamic>> terms = [
    {
      'number': '١ - ',
      'title': 'التعريف بالتطبيق:',
      'body':
          'تطبيق "أسنانك" هو منصة إلكترونية تهدف إلى تسهيل وصول المستخدمين إلى منتجات العناية بالأسنان مثل معاجين الأسنان، غسول الفم، وفرش الأسنان. لا يُعد التطبيق جهة رسمية أو ممثلًا لأي علامة تجارية، بل يقوم بشراء المنتجات من الأسواق المحلية أو من موزعين معتمدين ويعرضها للبيع للمستخدمين.'
    },
    {
      'number': '٢ - ',
      'title': 'عدم وجود وكالة رسمية:',
      'body':
          'صاحب التطبيق لا يحمل أي ترخيص أو وكالة رسمية من الشركات المصنعة للمنتجات المعروضة. جميع المنتجات يتم شراؤها بشكل فردي وإعادة بيعها دون أي علاقة مباشرة أو تعاقدية مع الشركات الأصلية.'
    },
    {
      'number': '٣ - ',
      'title': 'جودة المنتجات وصلاحيتها:',
      'body':
          'يتم بذل الجهد لضمان أن المنتجات المعروضة أصلية وسليمة، ولكن لا يتم تقديم أي ضمان رسمي من الشركات المصنعة. يتحمل المستخدم مسؤولية التحقق من تاريخ الصلاحية وسلامة المنتج قبل الاستخدام.'
    },
    {
      'number': '٤ - ',
      'title': 'سياسة الإرجاع والاستبدال:',
      'body':
          'لا يمكن إرجاع المنتجات بعد فتحها أو استخدامها. في حال وجود خلل واضح أو تلف في المنتج عند الاستلام، يجب التواصل خلال ٤٨ ساعة من تاريخ الاستلام. يجب تقديم صورة للمنتج المتضرر وإثبات الشراء.'
    },
    {
      'number': '٥ - ',
      'title': 'المسؤولية القانونية:',
      'body':
          'لا يتحمل صاحب التطبيق أي مسؤولية عن الأضرار الناتجة عن الاستخدام الخاطئ للمنتجات أو سوء التخزين من قبل المستخدم. لا يُعتبر التطبيق جهة طبية ولا يقدم أي نصائح علاجية أو تشخيصية، ويُنصح باستشارة طبيب الأسنان قبل استخدام أي منتج.'
    },
    {
      'number': '٦ - ',
      'title': 'سياسة الخصوصية:',
      'body':
          'يتم جمع بيانات المستخدمين مثل الاسم، رقم الهاتف، وعنوان التوصيل فقط لغرض إتمام الطلبات وتحسين الخدمة. لا يتم مشاركة البيانات مع أي جهة خارجية. يتم تخزين البيانات بشكل آمن، ويحق للمستخدم طلب حذف بياناته في أي وقت.'
    },
    {
      'number': '٧ - ',
      'title': 'الدفع والتوصيل:',
      'body':
          'يتم الدفع نقدًا عند الاستلام أو من خلال وسائل الدفع المتاحة داخل التطبيق. يتم التوصيل خلال المدة المحددة حسب المنطقة، وقد تختلف حسب توفر المنتج.'
    },
    {
      'number': '٨ - ',
      'title': 'التعديلات على الشروط:',
      'body':
          'يحتفظ صاحب التطبيق بالحق في تعديل هذه الشروط والأحكام في أي وقت دون إشعار مسبق. يُنصح المستخدمون بمراجعة هذه الصفحة بشكل دوري.'
    },
    {
      'number': '٩ - ',
      'title': 'التواصل والدعم:',
      'body': 'لأي استفسار أو شكوى، يرجى التواصل عبر ',
      'email': 'Info@asnank.net',
      'phone': '+9647702530198',
    },
  ];

  void launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  HelpCenterPresenter helpCenterPresenter = HelpCenterPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('📜 الشروط والأحكام', textDirection: TextDirection.rtl),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: terms.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 32, color: Colors.grey),
            itemBuilder: (context, index) {
              final term = terms[index];

              // Check if it's the last item (with contact info)
              if (term.containsKey('email') && term.containsKey('phone')) {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      fontFamily: 'Tajawal',
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: term['number'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: term['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text: 'لأي استفسار أو شكوى، يرجى التواصل عبر '),
                      TextSpan(
                        text: 'البريد الإلكتروني',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri(scheme: 'mailto', path: term['email'])),
                      ),
                      const TextSpan(text: ' أو عبر '),
                      TextSpan(
                        text: 'رقم الهاتف',
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchPhone(term['phone']),
                      ),
                      const TextSpan(text: ' المذكور داخل التطبيق.'),
                    ],
                  ),
                );
              }

              // البنود العادية
              return RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontFamily: 'Tajawal',
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: term['number'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: term['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${term['body']}'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

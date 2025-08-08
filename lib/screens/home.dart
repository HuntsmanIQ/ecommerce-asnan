import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/custom_ui/category_ui.dart';
import 'package:grostore/custom_ui/product_card.dart';
import 'package:grostore/custom_ui/shimmers.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/presenters/home_presenter.dart';
import 'package:grostore/screens/filter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final String? id;

  const Home({Key? key, this.id}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Provider.of<HomePresenter>(context, listen: false).setContext(context);
    Provider.of<HomePresenter>(context, listen: false).initState(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              getAssetImage("img.png"),
              width: getWidth(context),
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Consumer<HomePresenter>(builder: (context, data, child) {
            return RefreshIndicator(
              onRefresh: data.onRefresh,
              child: SingleChildScrollView(
                controller: data.homeScrollController,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSearchOption(context),
                      const SizedBox(
                        height: 10,
                      ),
                      buildSliderSection(data),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConfig.padding),
                        child: Row(
                          children: [
                            Text(
                              AppLang.local(context).top_categories_ucf,
                              style: StyleConfig.fs16fwBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      buildTopCategorySection(data),
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConfig.padding),
                        child: Row(
                          children: [
                            Text(
                              AppLang.local(context).best_selling_products_ucf,
                              style: StyleConfig.fs16fwBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          height: 200,
                          child: buildBestSellingProductSection(data)),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConfig.padding),
                        child: Row(
                          children: [
                            Text(
                              AppLang.local(context).all_products_ucf,
                              style: StyleConfig.fs16fwBold,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      allProducts(data),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  buildTopCategorySection(HomePresenter data) {
    return SizedBox(
      height: 89,
      child: data.isTopCategoryInitial
          ? ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: StyleConfig.padding),
              itemBuilder: (context, index) {
                return Button(
                  minWidth: 40,
                  onPressed: () {
                    MakeRoute.go(
                        context,
                        Filter(
                          category_id:
                              data.topCategoryList[index].id.toString(),
                        ));
                  },
                  child: SizedBox(
                    width: 100,
                    child: CategoryUi(
                        img: data.topCategoryList[index].thumbnailImage,
                        name: data.topCategoryList[index].name),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 8,
                );
              },
              itemCount: data.topCategoryList.length)
          : categoryShimmer(),
    );
  }

  SizedBox buildSliderSection(HomePresenter data) {
    return SizedBox(
      height: 200, // زيد الارتفاع هنا
      child: CarouselSlider(
        items: data.isHomeBannerInitial
            ? data.homeBannerImages.map((widget) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget, // احذف SizedBox(height: 500)
                  ),
                );
              }).toList()
            : sliderShimmer(),
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          height: 300, // لازم يكون نفس اللي فوق
          autoPlay: true,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            data.onChangeBannerIndex(index);
          },
        ),
      ),
    );
  }

  PreferredSize buildSearchOption(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(getWidth(context), 60),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
          width: getWidth(context),
          decoration: BoxDecorations.shadow(
            radius: 6.0,
          ),
          child: Button(
            onPressed: () => MakeRoute.go(
                context,
                Filter(
                  isFocus: true,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  getAssetIcon("search.png"),
                  height: 16,
                  width: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  AppLang.local(context).search_product_ucf,
                  style: StyleConfig.fs12cGrey,
                )
              ],
            ),
          ),
        ));
  }

  List<Widget> sliderShimmer() {
    return [
      Shimmers(width: getWidth(context) - 40, height: 200),
      Shimmers(width: getWidth(context) - 40, height: 200),
      Shimmers(width: getWidth(context) - 40, height: 200),
      Shimmers(width: getWidth(context) - 40, height: 200),
    ];
  }

  ListView categoryShimmer() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: StyleConfig.padding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmers(
            width: 76,
            height: 87,
            radius: 6.0,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 8,
            height: 10,
          );
        },
        itemCount: 10);
  }

  Widget allProductShimmer() {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: StyleConfig.padding),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmers(
            width: 160,
            height: 186,
            radius: 8,
          );
        });
  }

  Widget buildBestSellingProductSection(HomePresenter data) {
    return data.isBestSellingProductInitial
        // false
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: StyleConfig.padding),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (data.bestSellingProductList.isNotEmpty) {
                return ProductCard(
                  product: data.bestSellingProductList[index],
                  context: this.context,
                );
              } else {
                return const Text('لا توجد منتجات');
              }
            },
            separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
            itemCount: data.bestSellingProductList.length)
        : Shimmers.horizontalList(10, 160, 160);
  }

  Widget allProducts(HomePresenter data) {
    return data.isAllProductInitial
        ? GridView.builder(
            padding: EdgeInsets.only(
                left: StyleConfig.padding,
                right: StyleConfig.padding,
                bottom: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600
                  ? 4
                  : 2, // عدد الأعمدة
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7, // ✅ هذا مهم: نسبة العرض إلى الارتفاع
            ),
            itemCount: data.products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: data.products[index],
                context: this.context,
              );
            })
        : allProductShimmer();
  }
}

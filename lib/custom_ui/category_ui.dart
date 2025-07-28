import 'package:flutter/material.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/custom_ui/Image_view.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/helpers/device_info_helper.dart';


// class CategoryUi extends StatelessWidget {
//  late String img,name;
//    CategoryUi({Key? key,required this.img,required this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       decoration:BoxDecorations.shadow(radius: 6.0) ,
//       width: getWidth(context),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ImageView(url: img,width:40.0,height: 40.0,),
//           const SizedBox(height: 8,),
//           Text(name,style: StyleConfig.fs12,maxLines: 1,textAlign: TextAlign.center,)
//         ],
//       )
//     );
//   }
// }

class CategoryUi extends StatelessWidget {
  final String img, name;
  const CategoryUi({Key? key, required this.img, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Image Container
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: ImageView(
              url: img,
              width: 60,
              height: 60,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Text Below the Circle
        Text(
          name,
          style: StyleConfig.fs12,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}
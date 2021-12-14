import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wish_list_gx/core.dart';

class DialogBox extends StatelessWidget {
  const DialogBox(
          {Key? key,
            required this.title,
            required this.onClickAction,
            required this.onCancelAction
          }
        ) : super(key: key);

  final String title;
  final Function onClickAction;
  final Function onCancelAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:
          Container(
            padding: const EdgeInsets.all(20),
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              color: Get.theme.backgroundColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15,),
                // Text(title, style: Get.theme. primaryTextTheme.button),
                Text(title, style: Get.theme.textTheme.headline5),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWidget(formButton: CancelButton(onClic: onCancelAction)),
                    ButtonWidget(formButton: OkButton(onClic: onClickAction)),
                  ],
                )
              ],
            ),
          ),
    );
  }
}

// class _DialogButtonWidget extends StatelessWidget {
//   final FormButton formButton;
//
//   const _DialogButtonWidget({Key? key, this.formButton = const EmptyFormButton()})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: formButton.onButtonClicked,
//       child: Text(formButton.text),
//     );
//   }
// }

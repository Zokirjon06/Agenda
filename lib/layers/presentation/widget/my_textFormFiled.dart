import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? icon;
  final Function? onTap;
  final Function? onChanged;
  final String language;
  final TextInputType? keyBordtype;
  final maxLin;
  final minLin;
  final bool validator;
  final List<TextInputFormatter>? formatters;
  final bool sufix;
  final FocusNode? focusNode;
  final bool isDense;
  final double? conPad;
  final Color? color;
  final bool? readOnly;
  final InputDecoration? decoration;
  final String? Function(String? v)? validatorStr;

  const TaskField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.icon,
    this.onTap,
    this.onChanged,
    required this.language,
    this.keyBordtype,
    this.maxLin,
    this.minLin,
    required this.validator,
    this.formatters,
    required this.sufix,
    this.focusNode,
    required this.isDense,
    this.conPad,
    this.color,
    this.readOnly,
    this.decoration,
    this.validatorStr, 
    //  TextInputType keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (onTap != null) onTap!();
      },
      onChanged: (v) {
        if (onChanged != null) {
          onChanged!(v);
        }
      },
      controller: controller,
      keyboardType: keyBordtype,
      inputFormatters: formatters,
      cursorColor: Colors.white,
      readOnly: readOnly ?? false,
      focusNode: focusNode, // Fokus tugunini bog'lash

      // inputFormatters: formatter != null ? [formatter!] : null,
      style: const TextStyle(color: Colors.white),
      scrollPadding: EdgeInsets.zero,
      maxLines: maxLin,
      minLines: minLin,
      textCapitalization: TextCapitalization.words,
      decoration: decoration ?? InputDecoration(
        prefixIcon: sufix == true
            ? Icon(
                icon,
                color: Colors.blue,
              )
            : null,
        isDense: isDense,
        enabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: color == null ? Colors.white70 : color!,width: 1.5.w),
        ),
        contentPadding: conPad != null ? EdgeInsets.only(bottom: conPad!) : EdgeInsets.only(bottom: 0.h,),
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.5.w),
        ),
        border: const UnderlineInputBorder(),
        filled: false,
        hintText: labelText,
        hintStyle:  TextStyle(color: Colors.white54,fontSize: 18.sp),
        // hintText: hintText
      ),
      validator: validatorStr == null ? (value) {
        if (validator == true) {
          if (value == null || value.isEmpty) {
            return language == 'eng'
                ? 'Please enter $labelText'
                : language == 'rus'
                    ? 'Пожалуйста, введите $labelText'
                    : 'Iltimos, $labelText kiriting';
          }
        }
        return null; // Hech qanday xatolik yo'q bo'lsa, `null` qaytariladi
      } : validatorStr,
      // validator: (value) {
      //   if (validator == true) {
      //     if (value == null || value.isEmpty) {
      //      return showSnackBar(message: 'Iltoms $labelText kiriting', context: context);
      //     }
      //   }
      //   return null; // Hech qanday xatolik yo'q bo'lsa, `null` qaytariladi
      // },
    );
  }
}

// ----------------------------------------------------------------
// PlanField
// ----------------------------------------------------------------
// class PlanField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData icon;
//   final String language;
//   const PlanField(
//       {super.key,
//       required this.controller,
//       required this.hintText,
//       required this.icon,
//       required this.language});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       scrollPadding: EdgeInsets.zero,
//       maxLines: 3,
//       minLines: 1,
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color: Colors.deepPurple,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: Colors.blue),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         filled: false,
//         hintText: hintText,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return language == 'eng'
//               ? 'Please enter $hintText'
//               : language == 'rus'
//                   ? 'Пожалуйста, введите $hintText'
//                   : 'Iltimos, $hintText kiriting';
//         }
//         return null; // Hech qanday xatolik yo'q bo'lsa, `null` qaytariladi
//       },
//     );
//   }
// }

// ----------------------------------------------------------------
// CustomDropDown
// ----------------------------------------------------------------
class CustomDropdownField extends StatelessWidget {
  final String? selectedValue;
  final String labelText;
  final IconData icon;
  final List<String> items;
  final String language;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.selectedValue,
    required this.labelText,
    required this.icon,
    required this.items,
    required this.language,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(color: Colors.white),
      dropdownColor: Colors.deepPurple,
      icon: const Icon(Icons.arrow_drop_down),
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: const TextStyle(color: Colors.grey),
        // prefixIcon: Icon(
        //   icon,
        //   color: Colors.blue,
        // ),
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: const UnderlineInputBorder(),
      ),
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      value: selectedValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return language == 'eng'
              ? 'Please select $labelText'
              : language == 'rus'
                  ? 'Пожалуйста, выберите $labelText'
                  : 'Iltimos, $labelText tanlang';
        }
        return null;
      },
    );
  }
}

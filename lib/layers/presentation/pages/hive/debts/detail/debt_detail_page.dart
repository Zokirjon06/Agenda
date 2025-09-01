import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class DebtDetailPage extends StatefulWidget {
  final String language;
  final DebtsModel debt;
  const DebtDetailPage(
      {super.key,
      required this.language,
      required this.debt});

  @override
  State<DebtDetailPage> createState() => _DebtDetailPageState();
}

class _DebtDetailPageState extends State<DebtDetailPage> {
  late final DateFormat _allDate;
  List<DebtsDetailModel> detail = [];

  // Stream<List<DebtsDetailModel>> getDebtorsListStream() {
  //   // final box = Hive.box<DebtsModel>('debtsBox');
  //   // final box = Hive.box<DebtsDetailModel>("debtsDetailBox");
  //   return Hive.box<DebtsDetailModel>("debtsDetailBox").get(widget.debts).save();
  // }

 List<DebtsDetailModel> getDebtorsListStream() {
  final box = Hive.box<DebtsDetailModel>("debtsDetailBox");

  // Faqat ushbu qarzga tegishli detallari filter qilinadi
  final List<DebtsDetailModel> filtered = box.values
      .where((element) => element.fulName == widget.debt.name)
      .toList();
  return filtered;
}

void loadDetails() {
  setState(() {
    detail = getDebtorsListStream();
  });
}


  @override
  void initState() {
    _allDate = DateFormat.yMMMMd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
           loadDetails;
    setState(() {});
    super.initState();
  }

  Future<void> _deleteDebtor() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: AppColors.another,
          title: Text(
            widget.language == 'eng'
                ? 'Delete Debt'
                : widget.language == 'rus'
                    ? 'Удалить задачу'
                    : 'Qarzni o\'chirish',
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            widget.language == 'eng'
                ? 'Are you sure you want to delete this debt?'
                : widget.language == 'rus'
                    ? 'Вы уверены, что хотите удалить эту задачу?'
                    : 'Haqiqatan ham bu qarzni o\'chirmoqchimisiz?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                widget.language == 'eng'
                    ? 'Cancel'
                    : widget.language == 'rus'
                        ? 'Отмена'
                        : 'Bekor qilish',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                widget.language == 'eng'
                    ? 'Delete'
                    : widget.language == 'rus'
                        ? 'Удалить'
                        : 'O\'chirish',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
    );

    if (confirmed == true) {
      try {

        // delete debtor
        // final box = Hive.box<DebtsDetailModel>("debtsDetailBox");
        // if (box.values.contains(widget.debt)) {
          // box.delete(widget.debt.detail);
        // }

        //
        await widget.debt.delete();
        _showSnackBar(
          widget.language == 'eng'
              ? 'Task deleted successfully'
              : widget.language == 'rus'
                  ? 'Задача успешно удалена'
                  : 'Vazifa muvaffaqiyatli o\'chirildi',
        );

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        _showSnackBar("Xato: ${e.toString()}");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppbarLeadingIcon(),
        titleSpacing: 0,
        title: Text(widget.debt.name!.trim(),
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              )),
          IconButton(
            onPressed: _deleteDebtor,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
        foregroundColor: Colors.white,
        backgroundColor: AppColors.appBar,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () => _showBottomSheet(context),
      ),
      backgroundColor: AppColors.standartColor,
      body: Column(
        children: [
          Gap(10.h),
          StandartPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.language == 'eng'
                          ? "Total debtors"
                          : widget.language == 'rus'
                              ? ''
                              : 'Umumiy qarz',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Olingan: ${_allDate.format(widget.debt.date!)}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Gap(15.h),
                Center(
                  child: Text(
                    "${widget.debt.money.toMoney()} so'm",
                    style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Gap(15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Izoh: ${widget.debt.goal!.isEmpty ? 'Mavjud emas' : widget.debt.goal}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Muddat: ${_allDate.format(widget.debt.date!)}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1.h,
            color: AppColors.deviderDark,
          ),
          _getDebtorDetail()
        ],
      ),
    );
  }

  Widget _getDebtorDetail() {
    // final debtBool = detail.contains(widget.debt.detail);
    List<DebtsDetailModel> debt = detail;
    if (debt.isEmpty) {
      return const Center();
    }
    debt.sort((a, b) => a.date!.compareTo(b.date!));
    return Expanded(
      child: ListView.builder(
        itemCount: debt.length,
        itemBuilder: (context, index) {
          final item = debt[index];
          return item.detailAmount! > 0
              ? _buildDebtorsItem(item, index == 0)
              : _buildDebtorsItem1(item, index == 0);
        },
      ),
    );
  }

  Widget _buildDebtorsItem(DebtsDetailModel debt, bool text) {
    return Column(
      children: [
        if (text)
          Text(
            'Qo\'shimcha qarzlar',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          onTap: () {},
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.attach_money,
              size: 45.sp,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Qarzning oshishi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
          ),
          subtitle: Text(
            debt.detailComment.toString().trim(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${debt.detailAmount.toMoney()} so'm",
                style: TextStyle(color: Colors.green, fontSize: 22.sp),
              ),
              Text(
                _allDate.format(debt.date!),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Dividers(
          lightMode: true,
          inden: true,
        )
      ],
    );
  }

  Widget _buildDebtorsItem1(DebtsDetailModel debt, bool text) {
    return Column(
      children: [
        if (text)
          Text(
            'Qo\'shimcha qarzlar',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          onTap: () {},
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.attach_money,
              size: 45.sp,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Qarzning kamayishi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
          ),
          subtitle: Text(
            debt.detailComment.toString(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${debt.removDetailAmount.toMoney()} so'm",
                style: TextStyle(color: Colors.red, fontSize: 22.sp),
              ),
              Text(
                _allDate.format(debt.date!),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Dividers(
          lightMode: true,
          inden: true,
        )
      ],
    );
  }

  // --------------------------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  // _showBottomSheet---------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // showDragHandle: true,
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.all(Radius.zero),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      backgroundColor: AppColors.homeBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      // backgroundColor: const Color(0xffF5F5F5),
                      backgroundColor: Colors.green),
                  child: Text(
                    'Qarzning oshishi',
                    style: TextStyle(
                      color: Colors.white,
                      // color: const Color(0xff0C75AF),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      // backgroundColor: const Color(0xff0C75AF),
                      backgroundColor: Colors.red),
                  child: Text(
                    'Qarzning kamayishi',
                    style: TextStyle(
                      color: const Color(0xffF5F5F5),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
            ],
          ),
        );
      },
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/calculation/bloc/get_gold_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class CalculationPage extends StatefulWidget implements AutoRouteWrapper {
  const CalculationPage({super.key});

  @override
  _CalculationPageState createState() => _CalculationPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetGoldCubit(repository: context.repository.calculacationRepository),
        ),
      ],
      child: this,
    );
  }
}

class _CalculationPageState extends State<CalculationPage> {
  final RefreshController _refreshController = RefreshController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController daysController = TextEditingController();

  double? selectedPrice;
  double giveAmount = 0;
  double returnAmount = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetGoldCubit>(context).getGoldList();
  }

  void _calculate() {
    final weight = double.tryParse(weightController.text) ?? 0;
    final days = double.tryParse(daysController.text) ?? 0;
    const stavka = 0.293;

    if (selectedPrice != null && weight > 0 && days > 0) {
      giveAmount = selectedPrice! * weight;
      returnAmount = giveAmount + (giveAmount * stavka * days) / 100;
    } else {
      giveAmount = 0;
      returnAmount = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Калькулятор',
                    style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    Assets.images.logoHeader.path,
                    height: 34,
                  ),
                ],
              ),
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            header: const RefreshClassicHeader(),
            onRefresh: () {
              // BlocProvider.of<BannerCubit>(context).getMainPageBanner();
              // BlocProvider.of<CategoryCubit>(context).getCategory();
              _refreshController.refreshCompleted();
            },
            child: BlocBuilder<GetGoldCubit, GetGoldState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const CustomLoadingOverlayWidget();
                  },
                  loaded: (goldDTO) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(36),
                          Align(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: goldDTO
                                    .where(
                                      (item) => item.sample == '999.9' || item.sample == '750' || item.sample == '585',
                                    )
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return Padding(
                                    padding: EdgeInsets.only(right: 16.0, left: index == 0 ? 16 : 0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              children: [
                                                Text('AU ${item.sample}', style: AppTextStyles.fs14w500),
                                                const Gap(6),
                                                Text(
                                                  '${item.price} ₸',
                                                  style: AppTextStyles.fs14w600.copyWith(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.localized.goldSample,
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    SizedBox(
                                      width: 174,
                                      child: DropdownButtonFormField<double>(
                                        borderRadius: BorderRadius.circular(12), // applies to the dropdown menu
                                        decoration: InputDecoration(
                                          hintText: context.localized.goldSample,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        items: goldDTO
                                            .map(
                                              (e) => DropdownMenuItem<double>(
                                                value: double.tryParse(e.price!),
                                                child: Text(
                                                  'AU ${e.sample}',
                                                  style: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          selectedPrice = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.localized.theWeightofGoldInGrams,
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    SizedBox(
                                      width: 174,
                                      child: CustomTextField(
                                        controller: weightController,

                                        keyboardType: TextInputType.number,
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                        // onChanged: (value) {
                                        //   checkAllowTapButton();
                                        // },
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        context.localized.termtheMicrLoan,
                                        style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 174,
                                      child: CustomTextField(
                                        controller: daysController,
                                        keyboardType: TextInputType.number,
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                const Divider(),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.localized.amountOnHand,
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    Text(
                                      '${giveAmount.round()} ₸',
                                      style: AppTextStyles.fs16w700.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.localized.amountToBeRefunded,
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    Text(
                                      '${returnAmount.round()} ₸',
                                      style: AppTextStyles.fs16w700.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                const Divider(),
                                const Gap(23),
                                CustomButton(
                                  height: 60,
                                  onPressed: () {
                                    _calculate();
                                  },
                                  style: CustomButtonStyles.mainButtonStyle(context),
                                  child: Text(
                                    context.localized.calculate,
                                    style: AppTextStyles.fs18w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
}

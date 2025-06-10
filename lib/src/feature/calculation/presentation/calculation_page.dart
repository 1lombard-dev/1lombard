import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
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
      returnAmount = giveAmount + giveAmount * stavka * days;
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: List.generate(goldDTO.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          child: Column(
                                            children: [
                                              Text(
                                                'AU ${goldDTO[index].sample}',
                                                style: AppTextStyles.fs14w500.copyWith(
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              const Gap(5),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.red,
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                child: Text(
                                                  '${goldDTO[index].price} ₸',
                                                  style: AppTextStyles.fs14w600.copyWith(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
                                      'Проба золота',
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    SizedBox(
                                      width: 174,
                                      child: DropdownButtonFormField<double>(
                                        borderRadius: BorderRadius.circular(12), // applies to the dropdown menu
                                        decoration: InputDecoration(
                                          hintText: 'Проба золота',
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
                                      'Вес золота в грамм',
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Срок микрокредита, дни',
                                      style: AppTextStyles.fs16w500.copyWith(color: const Color(0xFF0A0A0A)),
                                    ),
                                    SizedBox(
                                      width: 174,
                                      child: CustomTextField(
                                        controller: daysController,

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
                                const Gap(10),
                                const Divider(),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Сумма на руки',
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
                                      'Сумма к возврату',
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
                                  onPressed: () {
                                    _calculate();
                                  },
                                  style: CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.red),
                                  child: const Text(
                                    'Рассчитать',
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

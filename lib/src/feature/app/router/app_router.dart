import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lombard/src/feature/app/presentation/pages/detail_image_page.dart';
import 'package:lombard/src/feature/app/presentation/pages/launcher.dart';
import 'package:lombard/src/feature/app/presentation/pages/temp_page.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/auth/presentation/auth.dart';
import 'package:lombard/src/feature/auth/presentation/pages/auth_page.dart';
import 'package:lombard/src/feature/calculation/presentation/calculation_page.dart';
import 'package:lombard/src/feature/loans/presentation/pages/loans_detail_page.dart';
import 'package:lombard/src/feature/loans/presentation/pages/loans_page.dart';
import 'package:lombard/src/feature/loans/presentation/pages/payment_information_page.dart';
import 'package:lombard/src/feature/main_feed/model/category_dto.dart';
import 'package:lombard/src/feature/main_feed/presentation/main_feed.dart';
import 'package:lombard/src/feature/main_feed/presentation/pages/change_subject_page.dart';
import 'package:lombard/src/feature/main_feed/presentation/pages/subject_page.dart';
import 'package:lombard/src/feature/map/presentation/map_page.dart';
import 'package:lombard/src/feature/profile/presentation/pages/about_us_page.dart';
import 'package:lombard/src/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:lombard/src/feature/profile/presentation/pages/faq_page.dart';
import 'package:lombard/src/feature/profile/presentation/profile.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: TempRoute.page),

        /// Root
        AutoRoute(
          page: LauncherRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: BaseMainFeedTab.page,
              children: [
                AutoRoute(
                  page: MainRoute.page,
                  initial: true,
                ),
                AutoRoute(page: SubjectRoute.page),
              ],
            ),
            AutoRoute(
              page: BaseCalculationTab.page,
              children: [
                AutoRoute(
                  page: CalculationRoute.page,
                  initial: true,
                ),
              ],
            ),
            AutoRoute(
              page: BaseLoansTab.page,
              children: [
                AutoRoute(
                  page: LoansRoute.page,
                  initial: true,
                ),
              ],
            ),
            AutoRoute(
              page: BaseMapTab.page,
              children: [
                AutoRoute(
                  page: MapRoute.page,
                  initial: true,
                ),
              ],
            ),
            AutoRoute(
              page: BaseProfileTab.page,
              children: [
                AutoRoute(
                  page: ProfileRoute.page,
                  initial: true,
                ),
              ],
            ),
          ],
        ),

        /// Auth
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: PasswordRecoveryRoute.page),
        AutoRoute(page: EnterSmsCodeRoute.page),
        // AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: NewPasswordRoute.page),

        // Other pages
        AutoRoute(page: AboutUsRoute.page),
        AutoRoute(page: FaqRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: ChangeSubjectRoute.page),

        AutoRoute(page: DetailImageRoute.page),

        //LOANS
        AutoRoute(page: LoansDetailRoute.page),
        AutoRoute(page: PaymentInformationRoute.page),
      ];
}

@RoutePage(name: 'BaseMainFeedTab')
class BaseMainFeedPage extends AutoRouter {
  const BaseMainFeedPage({super.key});
}

@RoutePage(name: 'BaseCalculationTab')
class BaseCalculationPage extends AutoRouter {
  const BaseCalculationPage({super.key});
}

@RoutePage(name: 'BaseLoansTab')
class BaseLoansPage extends AutoRouter {
  const BaseLoansPage({super.key});
}

@RoutePage(name: 'BaseMapTab')
class BaseMapPage extends AutoRouter {
  const BaseMapPage({super.key});
}

@RoutePage(name: 'BaseProfileTab')
class BaseProfilePage extends AutoRouter {
  const BaseProfilePage({super.key});
}

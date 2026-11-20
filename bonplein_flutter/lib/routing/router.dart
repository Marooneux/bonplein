import 'package:bonplein_flutter/routing/routes.dart';
import 'package:bonplein_flutter/ui/carte/carte_screen.dart';
import 'package:bonplein_flutter/ui/core/widgets/scaffold_with_nav_bar.dart';
import 'package:bonplein_flutter/ui/notifications/notifications_screen.dart';
import 'package:bonplein_flutter/ui/profil/profil_screen.dart';
import 'package:bonplein_flutter/ui/trejets/trajets_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: Routes.carte,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.carte,
              builder: (context, state) => const CarteScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.trajets,
              builder: (context, state) => const TrajetsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.notifications,
              builder: (context, state) => const NotificationScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profil,
              builder: (context, state) => const ProfilScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

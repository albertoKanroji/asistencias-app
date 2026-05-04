import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/home_constants.dart';
import '../../contractors/views/contractors_view.dart';
import '../../monitoring/views/monitoring_view.dart';
import '../../scanner/views/scanner_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      ScannerView(),
      MonitoringView(),
      ContractorsView(),
      SettingsView(),
    ];

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(HomeConstants.appTitle),
          actions: [
            Obx(() {
              final user = controller.authService.currentUserRx.value;
              final name = user?.name ?? HomeConstants.noProfile;
              final photo = user?.photo;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: (photo != null && photo.isNotEmpty)
                          ? NetworkImage(photo)
                          : null,
                      child: (photo == null || photo.isEmpty)
                          ? Text(
                              name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                              style: const TextStyle(fontSize: 12),
                            )
                          : null,
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 84,
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: HomeConstants.scannerTab),
            BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: HomeConstants.monitoringTab),
            BottomNavigationBarItem(icon: Icon(Icons.engineering), label: HomeConstants.contractorsTab),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: HomeConstants.settingsTab),
          ],
        ),
      ),
    );
  }
}

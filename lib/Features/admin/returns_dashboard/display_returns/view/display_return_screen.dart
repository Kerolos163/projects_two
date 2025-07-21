import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Features/admin/returns_dashboard/display_returns/widgets/return_status_dropdown.dart';
import 'package:projects_two/Features/admin/returns_dashboard/display_returns/widgets/return_tile.dart';
import 'package:projects_two/Features/admin/returns_dashboard/viewmodel/return_dashboard_provider.dart';
import 'package:provider/provider.dart';

class DashboardDisplayReturnsScreen extends StatefulWidget {
  const DashboardDisplayReturnsScreen({super.key});

  @override
  State<DashboardDisplayReturnsScreen> createState() =>
      _DashboardDisplayReturnsScreenState();
}

class _DashboardDisplayReturnsScreenState
    extends State<DashboardDisplayReturnsScreen> {
  String selectedStatus = 'All';
  final List<String> statusOptions = [
    'All',
    'pending',
    'fulfilled',
    'rejected',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Returns".tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Consumer<ReturnsDashboardProvider>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredReturns = selectedStatus == 'All'
              ? controller.returns
              : controller.returns
                    .where((r) => r.status == selectedStatus)
                    .toList();

          return Column(
            children: [
              ReturnStatusDropdown(
                selectedStatus: selectedStatus,
                statusOptions: statusOptions,
                onChanged: (status) => setState(() => selectedStatus = status),
              ),
              Expanded(
                child: filteredReturns.isEmpty
                    ? Center(
                        child: Text(
                          "No returns available for this status.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredReturns.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Colors.transparent),
                        itemBuilder: (_, index) {
                          final returnRequest = filteredReturns[index];
                          return ReturnTile(
                            returnRequest: returnRequest,
                            onUpdated: () async {
                              await controller.fetchAllReturns();
                              final updatedReturn = controller.returns
                                  .firstWhere(
                                    (r) => r.id == returnRequest.id,
                                    orElse: () => returnRequest,
                                  );

                              if (selectedStatus != 'All' &&
                                  updatedReturn.status != selectedStatus) {
                                setState(() => selectedStatus = 'All');
                              } else {
                                setState(() {});
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/api/api_state.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../user_details/view/user_details_screen.dart';
import '../../viewmodel/users_dashboard_provider.dart';
import 'package:provider/provider.dart';

class DashboardDisplayUsersScreen extends StatelessWidget {
  const DashboardDisplayUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDashboardProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.users.tr(),
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
          body: provider.apiState == ApiState.loading
              ? const Center(child: CircularProgressIndicator())
              : provider.users.isEmpty
              ? Center(
                  child: Text(
                    "No available users",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.separated(
                  itemCount: provider.users.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.transparent),
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Image.network(
                              '${ApiEndPoints.baseUrl}uploads/${user.avatar}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.person, size: 28),
                                  ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppStrings.user.tr()}: ${user.fName}",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              "${AppStrings.role.tr()}: ${user.role}",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: provider,
                                child: UserDetailsScreen(user: user),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

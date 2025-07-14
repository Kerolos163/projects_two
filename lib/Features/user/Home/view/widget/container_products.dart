import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/Theme/app_provider.dart';
import '../../../../../Core/constant/app_colors.dart';


class ProductContainer extends StatelessWidget {
  final Color? colorr;
  final String textt;
  final String btntext;
  const ProductContainer({
    super.key,
    required this.btntext,
    required this.colorr,
    required this.textt,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (60 / 812),
      width: MediaQuery.of(context).size.height * (340 / 375),
      decoration: BoxDecoration(
        color: colorr,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * (13 / 812),
              vertical: MediaQuery.of(context).size.height * (13 / 812),
            ),
            child: Row(
              children: [
                Text(
                  textt,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * (35 / 375),
                ),
                Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    return InkWell(
                      onTap: () => appProvider.changeIndex(index: 1),
                      child: Container(
                        height: MediaQuery.of(context).size.height * (25 / 812),
                        width: MediaQuery.of(context).size.height * (40 / 375),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            "$btntext →",
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

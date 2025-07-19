import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Core/widgets/rating_bar_widget.dart';
import 'package:toastification/toastification.dart';

import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/widgets/app_text_form_field.dart';
import '../../model/add_review_param_model.dart';
import '../../viewmodel/details_provider.dart';

class AddReviewBottomSheet extends StatefulWidget {
  const AddReviewBottomSheet({
    super.key,
    required this.provider,
    required this.productId,
  });
  final DetailsProvider provider;
  final String productId;

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  late TextEditingController reviewController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    reviewController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            RatingBarWidget(
              initialRating: 0,
              itemSize: 40,
              ignoreGestures: false,
              onRatingUpdate: (rating) => widget.provider.changeRating(rating),
            ),
            SizedBox(height: 18),
            AppTextFormField(
              hintText: AppStrings.review.tr(),
              maxLines: 5,
              controller: reviewController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.pleaseEnterReview.tr();
                }
                return null;
              },
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: Size(1.sw, 50)),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await widget.provider.addReview(
                    model: AddReviewParamModel(
                      title: reviewController.text.trim(),
                      rating: widget.provider.rating.toString(),
                      product: widget.productId,
                    ),
                  );
                  if (context.mounted) {
                    if (widget.provider.reviewState == ReviewState.success) {
                      await widget.provider.getProductReviews(
                        productId: widget.productId,
                      );
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      toastification.show(
                        type: ToastificationType.error,
                        alignment: Alignment.bottomCenter,
                        context: context,
                        title: Text(widget.provider.message),
                        autoCloseDuration: const Duration(seconds: 5),
                      );
                    }
                  }
                }
              },
              child: Text(AppStrings.addReview.tr()),
            ),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

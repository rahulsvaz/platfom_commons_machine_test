import 'package:flutter/material.dart';
import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import '../../../../shared/style/text_styles.dart';
import '../../../../shared/widgets/app_image.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Palette.kPrimary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: user.avatar,
              width: 72,
              height: 72,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              backgroundColor: Palette.lightGrayBg,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          user.fullName,
                          style: Styles.poppins16Bold.copyWith(
                            color: Palette.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: user.isSynced
                              ? Palette.kPrimary.withValues(alpha: 0.10)
                              : Palette.orangeColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          user.isLocalCreated
                              ? (user.isSynced ? 'App User' : 'Pending Sync')
                              : 'API User',
                          style: Styles.poppins12Medium.copyWith(
                            color: user.isSynced
                                ? Palette.kPrimary
                                : Palette.orangeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email.isNotEmpty ? user.email : 'Email not available',
                    style: Styles.poppins12.copyWith(
                      color: Palette.subTextColor,
                    ),
                  ),
                  if (user.job != null && user.job!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      user.job!,
                      style: Styles.poppins14SemiBold.copyWith(
                        color: Palette.textColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

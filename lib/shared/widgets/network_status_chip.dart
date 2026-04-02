import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platfom_commons_machine_test/core/network/connectivity_cubit.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';

class NetworkStatusChip extends StatelessWidget {
  const NetworkStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        final isOnline = state.isOnline;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isOnline
                ? Palette.green.withValues(alpha: 0.12)
                : Palette.redColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                size: 16,
                color: isOnline ? Palette.green : Palette.redColor,
              ),
              const SizedBox(width: 6),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: Styles.poppins12SemiBold.copyWith(
                  color: isOnline ? Palette.green : Palette.redColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

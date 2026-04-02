import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platfom_commons_machine_test/core/navigation/app_routes.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/bloc/user_bloc.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';
import 'package:platfom_commons_machine_test/shared/widgets/app_back_button.dart';
import 'package:platfom_commons_machine_test/shared/widgets/bg_with_stack.dart';
import 'package:platfom_commons_machine_test/shared/widgets/network_status_chip.dart';
import 'package:platfom_commons_machine_test/shared/widgets/primary_button.dart';
import 'package:platfom_commons_machine_test/shared/widgets/text_field_widget.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  String? _handledUserId;

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) =>
          previous.createdUser?.storageId != current.createdUser?.storageId,
      listener: (context, state) {
        final createdUser = state.createdUser;
        if (createdUser == null || _handledUserId == createdUser.storageId) {
          return;
        }
        _handledUserId = createdUser.storageId;
        context.pushReplacement(AppRoutes.movies, extra: createdUser);
      },
      child: Scaffold(
        backgroundColor: Palette.lightGrayBg,
        body: BackGroundWithStack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [AppBackButton(), NetworkStatusChip()],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Create User',
                      style: Styles.poppins30Bold.copyWith(
                        color: Palette.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If you are offline, we will store the user in Hive and sync it automatically later.',
                      style: Styles.poppins14.copyWith(
                        color: Palette.subTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Palette.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.kPrimary.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              controller: _nameController,
                              label: 'Name',
                              hintText: 'Enter full name',
                              borderRadius: 16,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _jobController,
                              label: 'Job',
                              hintText: 'Enter job title',
                              borderRadius: 16,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Job is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                return PrimaryButton(
                                  text: 'Save And Open Movies',
                                  loading: state.isCreatingUser,
                                  onTap: () {
                                    if (_formKey.currentState?.validate() !=
                                        true) {
                                      return;
                                    }
                                    context.read<UserBloc>().add(
                                      AddUserEvent(
                                        name: _nameController.text.trim(),
                                        job: _jobController.text.trim(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

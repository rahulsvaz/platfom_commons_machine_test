import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platfom_commons_machine_test/core/navigation/app_routes.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/bloc/user_bloc.dart';
import 'package:platfom_commons_machine_test/features/users/presentation/widgets/user_card.dart';
import 'package:platfom_commons_machine_test/shared/style/palette.dart';
import 'package:platfom_commons_machine_test/shared/style/text_styles.dart';
import 'package:platfom_commons_machine_test/shared/widgets/animated_card_wrapper.dart';
import 'package:platfom_commons_machine_test/shared/widgets/bg_with_stack.dart';
import 'package:platfom_commons_machine_test/shared/widgets/network_status_chip.dart';

class UsersListingPage extends StatefulWidget {
  const UsersListingPage({super.key});

  @override
  State<UsersListingPage> createState() => _UsersListingPageState();
}

class _UsersListingPageState extends State<UsersListingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent * 0.75;
    if (_scrollController.position.pixels >= threshold) {
      context.read<UserBloc>().add(const LoadMoreUsersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Palette.redColor,
              content: Text(state.errorMessage!, style: Styles.poppins14White),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Palette.lightGrayBg,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(
              AppRoutes.addUser,
              extra: context.read<UserBloc>(),
            ),
            backgroundColor: Palette.kPrimary,
            label: Text(
              'Add User',
              style: Styles.poppins12SemiBold.copyWith(color: Palette.white),
            ),
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: Palette.white,
            ),
          ),
          body: BackGroundWithStack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [NetworkStatusChip()],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'User List',
                              style: Styles.poppins30Bold.copyWith(
                                color: Palette.textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scroll to paginate users. Tap a user to open the movie list. App-created users can bookmark movies offline.',
                              style: Styles.poppins14.copyWith(
                                color: Palette.subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: _ReconnectHint(),
                        ),
                      ),
                    if (state.status == UserStatus.loading &&
                        state.users.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.users.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No users available',
                            style: Styles.poppins16Medium.copyWith(
                              color: Palette.subTextColor,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        sliver: SliverList.builder(
                          itemCount:
                              state.users.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.users.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final user = state.users[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: AnimatedCardWrapper(
                                index: index,
                                child: UserCard(
                                  user: user,
                                  onTap: () => context.push(
                                    AppRoutes.movies,
                                    extra: user,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReconnectHint extends StatelessWidget {
  const _ReconnectHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Palette.kPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Reconnecting...',
          style: Styles.poppins12Medium.copyWith(color: Palette.subTextColor),
        ),
      ],
    );
  }
}

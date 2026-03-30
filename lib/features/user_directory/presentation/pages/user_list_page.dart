import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../bloc/user_bloc.dart';
import '../widgets/search_bar.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_shimmer.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(FetchUsersEvent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(LoadMoreUsersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: BlocListener<UserBloc, UserState>(
          listenWhen: (previous, current) => previous.status != current.status && current.status == UserStatus.failure,
          listener: (context, state) {
            if (state.status == UserStatus.failure) {
              CustomSnackBar.show(context, message: state.errorMessage, type: SnackBarType.error);
            }
          },
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case UserStatus.loading:
                        return const LoadingShimmer();
                      case UserStatus.failure:
                        return _buildErrorState(context, state.errorMessage);
                      case UserStatus.empty:
                        return _buildEmptyState(context);
                      case UserStatus.success:
                      case UserStatus.initial:
                        if (state.pagedUsers.isEmpty && state.status == UserStatus.success) {
                          return _buildEmptyState(context);
                        }
                        return _buildUserList(state);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Directory',
                style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: const Color(0xFF1E2661)),
              ),
              // _buildConnectivityDot(),
            ],
          ),

          const SizedBox(height: 20),
          UserSearchBar(
            onSearch: (query) {
              context.read<UserBloc>().add(SearchUsersEvent(query));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(UserState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(FetchUsersEvent());
      },
      child: AnimationLimiter(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          itemCount: state.hasReachedMax ? state.pagedUsers.length : state.pagedUsers.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.pagedUsers.length) {
              return LoadingShimmer.singleItem();
            }

            final user = state.pagedUsers[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: UserCard(
                    user: user,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailPage(user: user)));
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text('Try searching for something else.', style: GoogleFonts.outfit(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(FetchUsersEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildConnectivityDot() {
  //   return BlocBuilder<ConnectivityCubit, bool>(
  //     builder: (context, isConnected) {
  //       return Container(
  //         width: 12,
  //         height: 12,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: isConnected ? Colors.green : Colors.red,
  //           boxShadow: [
  //             BoxShadow(
  //               color: (isConnected ? Colors.green : Colors.red).withValues(
  //                 alpha: 0.4,
  //               ),
  //               blurRadius: 8,
  //               spreadRadius: 2,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}

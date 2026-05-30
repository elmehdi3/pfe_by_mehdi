import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';
import 'user_search_screen.dart';

class InvitationsManagementScreen extends StatefulWidget {
  const InvitationsManagementScreen({super.key});

  @override
  State<InvitationsManagementScreen> createState() =>
      _InvitationsManagementScreenState();
}

class _InvitationsManagementScreenState
    extends State<InvitationsManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = Provider.of<UserProvider>(context, listen: false).user?.id;
      if (uid != null) {
        Provider.of<FriendProvider>(context, listen: false).startListening(uid);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<FriendProvider>(
          builder: (_, fp, __) => Row(
            children: [
              const Text(
                'Invitations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (fp.pendingCount > 0) ...[
                const SizedBox(width: 8),
                Badge(
                  label: Text('${fp.pendingCount}'),
                  backgroundColor: AppColors.primary,
                ),
              ],
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserSearchScreen()),
            ),
            tooltip: 'Find Players',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          tabs: const [
            Tab(text: 'FRIEND REQUESTS'),
            Tab(text: 'MY FRIENDS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_FriendRequestsTab(), _FriendsTab()],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tab 1: Incoming friend requests
// ─────────────────────────────────────────────

class _FriendRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
      builder: (context, fp, _) {
        final requests = fp.incomingRequests;

        if (requests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  color: AppColors.primary,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'No pending requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'When someone sends you a friend request\nit will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final req = requests[i];
            return _RequestCard(
              request: req,
              onAccept: () => fp.acceptRequest(req['id']),
              onDecline: () => fp.declineRequest(req['id']),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Tab 2: Accepted friends list
// ─────────────────────────────────────────────

class _FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
      builder: (context, fp, _) {
        final myUid =
            Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
        final friends = fp.friends;

        if (friends.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.group_outlined,
                  color: AppColors.primary,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No friends yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserSearchScreen()),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Find Players'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: friends.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final f = friends[i];
            final fId = f['id'] as String;
            return _FriendTile(
              friendId: fId,
              onRemove: () => fp.removeFriend(myUid, fId),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Friend tile (shared by both tabs)
// ─────────────────────────────────────────────

class _FriendTile extends StatelessWidget {
  final String friendId;
  final VoidCallback onRemove;

  const _FriendTile({required this.friendId, required this.onRemove});

  Future<Map<String, dynamic>?> _fetchProfile() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();
      return snap.data();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchProfile(),
      builder: (context, snapshot) {
        final p = snapshot.data;
        final name = p?['fullName'] ?? '…';
        final rank = p?['gameRank'] ?? 'Unranked';
        final imageUrl = p?['profileImage'] as String?;

        return AppCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surfaceContainerHigh,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      rank,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: AppColors.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.onSurfaceVariant,
                ),
                onSelected: (v) {
                  if (v == 'remove') onRemove();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      'Remove Friend',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Friend request card
// ─────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final fromUid = request['from'] as String? ?? '?';

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromUid,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      'Sent you a friend request',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: AppColors.secondary, size: 8),
                    SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('ACCEPT'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('DECLINE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../services/database_service.dart';

/// Screen for searching players by Gamertag and sending friend requests.
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isSearching = false;
  final Set<int> _pendingUids = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    final results = await friendProvider.searchUsers(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  Future<void> _sendRequest(int toUid) async {
    final myUid = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (myUid == null) return;
    setState(() => _pendingUids.add(toUid));
    final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    await friendProvider.sendRequest(myUid, toUid);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Friend request sent! ✅')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Find Players',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FriendsListScreen()),
            ),
            tooltip: 'My Friends',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _search,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search by Gamertag...',
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceVariant.withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _results = []);
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // ── Results ─────────────────────────────────────
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _results.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final player = _results[index];
                      final uid = player['id'] is String
                          ? int.parse(player['id'])
                          : player['id'] as int;
                      final myUid = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).user?.id;
                      return _PlayerSearchCard(
                        player: player,
                        isMe: uid == myUid,
                        isPending: _pendingUids.contains(uid),
                        onSendRequest:
                            (uid == myUid || _pendingUids.contains(uid))
                            ? null
                            : () => _sendRequest(uid),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchController.text.isEmpty ? Icons.search : Icons.person_off,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Search for players'
                : 'No players found',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find your friends by their Gamertag',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Player card shown in search results
// ─────────────────────────────────────────────────────────

class _PlayerSearchCard extends StatelessWidget {
  final Map<String, dynamic> player;
  final bool isMe;
  final bool isPending;
  final VoidCallback? onSendRequest;

  const _PlayerSearchCard({
    required this.player,
    this.isMe = false,
    this.isPending = false,
    this.onSendRequest,
  });

  @override
  Widget build(BuildContext context) {
    final name = player['fullName'] ?? 'Unknown';
    final rank = player['gameRank'] ?? 'Unranked';
    final game = player['favoriteGame'] ?? '—';
    final imageUrl = player['profileImage'] as String?;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child: imageUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.military_tech,
                      color: AppColors.secondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rank,
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.sports_esports,
                      color: AppColors.onSurfaceVariant,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        game,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isMe)
            const Chip(label: Text('You', style: TextStyle(fontSize: 11)))
          else if (isPending)
            const Chip(
              avatar: Icon(
                Icons.hourglass_top,
                size: 14,
                color: AppColors.secondary,
              ),
              label: Text('Sent', style: TextStyle(fontSize: 11)),
            )
          else
            FilledButton.icon(
              onPressed: onSendRequest,
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Add'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Friends List Screen
// ─────────────────────────────────────────────────────────

class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendProvider>(
      builder: (context, friendProvider, _) {
        final myUid =
            Provider.of<UserProvider>(context, listen: false).user?.id ?? 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Friends (${friendProvider.friends.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Badge(
                  isLabelVisible: friendProvider.pendingCount > 0,
                  label: Text('${friendProvider.pendingCount}'),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () =>
                    _showRequestsSheet(context, friendProvider, myUid),
                tooltip: 'Requests',
              ),
              IconButton(
                icon: const Icon(Icons.person_search, color: AppColors.primary),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserSearchScreen()),
                ),
                tooltip: 'Find Players',
              ),
            ],
          ),
          body: friendProvider.friends.isEmpty
              ? _buildEmpty(context)
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: friendProvider.friends.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final friend = friendProvider.friends[i];
                    final friendId = friend['id'] is String
                        ? int.parse(friend['id'])
                        : friend['id'] as int;
                    return _FriendTile(
                      friendId: friendId,
                      onRemove: () =>
                          friendProvider.removeFriend(myUid, friendId),
                    );
                  },
                ),
        );
      },
    );
  }

  void _showRequestsSheet(BuildContext context, FriendProvider fp, int myUid) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final reqs = fp.incomingRequests;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Incoming Requests (${reqs.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (reqs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No pending requests',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                )
              else
                ...reqs.map(
                  (req) => _RequestTile(
                    request: req,
                    onAccept: () => fp.acceptRequest(req['id']),
                    onDecline: () => fp.declineRequest(req['id']),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.group_outlined,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No friends yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search for players to grow your network',
            style: TextStyle(color: AppColors.onSurfaceVariant),
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
}

// ─────────────────────────────────────────────────────────
//  Individual friend tile
// ─────────────────────────────────────────────────────────

class _FriendTile extends StatelessWidget {
  final int friendId;
  final VoidCallback onRemove;

  const _FriendTile({required this.friendId, required this.onRemove});

  Future<Map<String, dynamic>?> _fetchProfile() async {
    try {
      final user = await DatabaseService().getUserProfile(friendId);
      if (user != null) {
        return {
          'fullName': user.fullName,
          'gameRank': user.gameRank,
          'profileImage': user.profileImage,
        };
      }
      return null;
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
              // Online indicator
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

// ─────────────────────────────────────────────────────────
//  Incoming request tile (shown in bottom sheet)
// ─────────────────────────────────────────────────────────

class _RequestTile extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestTile({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final fromUid = request['from']?.toString() ?? '?';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fromUid,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          FilledButton(
            onPressed: onAccept,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Accept'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onDecline,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}

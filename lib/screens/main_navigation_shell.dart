import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_dashboard_screen.dart';
import 'matchmaking_search_screen.dart';
import 'player_profile_screen.dart';
import 'real_time_chat_screen.dart';
import 'squad_management_screen.dart';
import 'leaderboard_screen.dart';
import 'invitations_management_screen.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const MatchmakingSearchScreen(),
    const SquadManagementScreen(),
    const RealTimeChatScreen(squadId: 'default'),
    const LeaderboardScreen(),
    const PlayerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.8),
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBYJXqi_CgO3rzBIb4SlKzIwtGK7FZWc3qSumJ4OcA_lHOyFgzWnq3jBcPAgV4bMybmmipmOV-4LAb6monAWOTQaRwDgXjO9p3tb2AAU6VAJ1AG7SjawVtHbbhg9dGHK0dbKp-tU0nTTW7PqyOlroEd_8OtFKG1C8cW0BanjBY6kHljdyIfWmm5lZyD3FPtcKtfgv-6M_nJbomRiJFweM6yvUNp6TcdaD8B8ckqiTRQZRANrnCbdmFgKhXp2fIY5-PVnsKY-S23_Y8',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'TEAMUP',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        actions: [
          // Friend requests badge
          Consumer<FriendProvider>(
            builder: (context, fp, _) => IconButton(
              icon: Badge(
                isLabelVisible: fp.pendingCount > 0,
                label: Text('${fp.pendingCount}'),
                child: const Icon(
                  Icons.group_outlined,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InvitationsManagementScreen(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest.withOpacity(0.3),
          border: const Border(top: BorderSide(color: Colors.white10)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports),
              label: 'Match',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Squad'),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Ranks',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

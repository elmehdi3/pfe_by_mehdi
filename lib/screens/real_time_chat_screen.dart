import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../theme/app_colors.dart';

class RealTimeChatScreen extends StatelessWidget {
  const RealTimeChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar (Desktop only)
        if (MediaQuery.of(context).size.width > 900)
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withOpacity(0.4),
              border: const Border(right: BorderSide(color: Colors.white10)),
            ),
            child: _buildSidebar(),
          ),

        // Chat Area
        Expanded(
          child: Column(
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.5),
                  border: const Border(
                    bottom: BorderSide(color: Colors.white10),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBF0dx4D9Ff54Ux9l1gwmDn-9eKAmteS5HRY1CS2y89zyDIBEfhwjeAFCx2o_ikNGy25zrtDJ2OREnJfnNf-bwDzzHzkYHrPcaU7IomukcLccFhfSCN-qTU8xFog0np8waaqDTvSNvvX4P3gj0fYH2IM77uBLWkeBkGG76md8-jD1pyRlC5b-mZK55-hqbOqIVo8OQMLoQhZ922UaDU6cmM2JR9AtNH9GAzOSOTjUpl3_DaZOCoCRad2i0DNsmO_9je5hZrtedqV0k',
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Neon Knights Squad',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '5 Online • 12 Members',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: const [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'TODAY',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ChatBubble(
                      text:
                          "We need a solid 5th for the tournament tonight. Anyone got a ringer?",
                      sender: "Viper",
                      time: "10:42 AM",
                      avatarUrl:
                          "https://lh3.googleusercontent.com/aida-public/AB6AXuBOLJ80HMoxjqn81Nbhd51kjq39may571rdQpp5X1_X2sMQGUyaTQ5AjCxPngLHdH6Pop8WRF2O793KbFy6pw2LxF_NUJQszog2LdTnKXid8GpaXA6I0gf_G2xOSgeVdd4XSJm8uFfwtgtd7f_P4TgaVFueIREv5wut3ftpMj4xxJD88DrUd9CZDZX7g7lb6mUmREldDN619jDyCdjUQvREhGmA_1oQAMAGjTzkuoTmrGrSLjvW4KSt0dwsCX61Ng08jWJ63f-nwo0",
                      isMe: false,
                    ),
                    ChatBubble(
                      text: "I pinged Shadow. He might be free.",
                      sender: "Me",
                      time: "10:45 AM",
                      avatarUrl:
                          "https://lh3.googleusercontent.com/aida-public/AB6AXuDcpPZeCjgtfz1Pz--odQcH9NbjADWgyz-QShjC86wq0loGnSmcdeG9mrLIkuCdvSorbdtGqqu4yKVfPZjZQX68SpV2Ixnq_yZjtATc6b5EloGLQwVnnrNXw7btq-YSwPafN9n4b6doDO8UQoyCZxypB15WugulR9y5AdC7tnaiz4ge1MxLLbp4snT91wZKiLAXVnXuo1UzRBRtRg-GsFcM1eV_pbjhLbD-PAZQ-wr11idrVmLnz-NqkOcEQZq0kSOKDHkqRn-1J60",
                      isMe: true,
                    ),
                  ],
                ),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Message Neon Knights...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.sentiment_satisfied_alt,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Find players or squads...',
              prefixIcon: Icon(Icons.search, size: 18),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const _SidebarHeader(label: 'SQUADS'),
              const _SidebarItem(
                title: 'Neon Knights',
                subtitle: 'Viper: Let\'s run it back!',
                time: 'Now',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBF0dx4D9Ff54Ux9l1gwmDn-9eKAmteS5HRY1CS2y89zyDIBEfhwjeAFCx2o_ikNGy25zrtDJ2OREnJfnNf-bwDzzHzkYHrPcaU7IomukcLccFhfSCN-qTU8xFog0np8waaqDTvSNvvX4P3gj0fYH2IM77uBLWkeBkGG76md8-jD1pyRlC5b-mZK55-hqbOqIVo8OQMLoQhZ922UaDU6cmM2JR9AtNH9GAzOSOTjUpl3_DaZOCoCRad2i0DNsmO_9je5hZrtedqV0k',
                isActive: true,
                hasUnread: true,
              ),
              const _SidebarItem(
                title: 'Aim Bots',
                subtitle: 'System: Match found.',
                time: '2h',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCBPCQlbtaf0wJ-Rl4MTI611llbVcyOIxOAMO94gMjXTZioPSeKf-9JrmA7G3oMkUKUAjJ8IMsfEIl6CYK60asaIbLMTePcYaW2g35oTDpGoDVCAUCXikdwW-EZyfkEPXIeFyXftPvx2oeKaBplQzcwtB8XpLrYWG_e14AMZPqObKK8d9LUBOHiz88Mx9Rd3eOHjDdsl5kZA4Yj9Afcb9XIyn2E0turc0k54lvxD9LupH-rqygHKVGWPy3JjCWi9If8VUGXyAGkpd4',
              ),
              const _SidebarHeader(label: 'DIRECT MESSAGES'),
              const _SidebarItem(
                title: 'xX_SniperQueen_Xx',
                subtitle: 'Gg wp',
                time: '1d',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBI8oadrN3uFNptW0StED5ft8lDoP0TqNWGmi3CfVfF2pVhFqJtkztqqiAi6lI3ONzQXVMq-aEUIs9FPEOY7mdlUv8EQmSF19D8iOZH42jlzYGLmrlh1AepI86LYEm7w4FTULRxywMxGjAdCzAvM281yNtUZbOr5K00svy4W-S7Joo5MEn6GiFvIE7y8WRO__OCzK1_uKeZbOCJ8JBd3ryrlmkaZoeAYUFYw8Vr9ZSpwi-9l84dpxwQLNzawqatWtUOI8XiaZyT5n8',
                isOnline: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final String label;
  const _SidebarHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl;
  final bool isActive;
  final bool hasUnread;
  final bool isOnline;

  const _SidebarItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
    this.isActive = false,
    this.hasUnread = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.surfaceContainerHigh.withOpacity(0.5)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOnline)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (hasUnread)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

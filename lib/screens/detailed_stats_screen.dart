import 'package:flutter/material.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';

class DetailedStatsScreen extends StatelessWidget {
  const DetailedStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performance Stats'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Analyze your competitive journey and tactical metrics.', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
            const SizedBox(height: 32),
            
            // Stats Bento
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: const [
                _StatsCard(label: 'WIN RATE', value: '68.4%', icon: Icons.emoji_events, color: AppColors.tertiary),
                _StatsCard(label: 'MATCHES', value: '1,204', icon: Icons.sports_esports, color: AppColors.secondary),
                _StatsCard(label: 'K/D RATIO', value: '2.45', icon: Icons.track_changes, color: Colors.orange),
                _StatsCard(label: 'PLAY TIME', value: '450h', icon: Icons.schedule, color: AppColors.primary),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Charts Section
            LayoutBuilder(builder: (context, constraints) {
               return Column(
                 children: [
                   AppCard(
                     padding: const EdgeInsets.all(24),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const Text('Rank Evolution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                               decoration: BoxDecoration(border: Border.all(color: AppColors.primary.withOpacity(0.3)), borderRadius: BorderRadius.circular(20)),
                               child: const Text('SEASON 5', style: TextStyle(color: AppColors.primary, fontSize: 8, fontWeight: FontWeight.bold)),
                             ),
                           ],
                         ),
                         const SizedBox(height: 48),
                         _FauxLineChart(),
                       ],
                     ),
                   ),
                   const SizedBox(height: 32),
                   AppCard(
                     padding: const EdgeInsets.all(24),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text('Role Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                         const SizedBox(height: 32),
                         Center(child: _FauxDonutChart()),
                         const SizedBox(height: 32),
                         const Wrap(
                           spacing: 16,
                           runSpacing: 8,
                           alignment: WrapAlignment.center,
                           children: [
                             _ChartLegend(label: 'Assault', color: AppColors.primaryContainer),
                             _ChartLegend(label: 'Support', color: AppColors.secondaryContainer),
                             _ChartLegend(label: 'Sniper', color: AppColors.tertiary),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ],
               );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color == AppColors.tertiary ? AppColors.tertiary : AppColors.onSurface)),
        ],
      ),
    );
  }
}

class _FauxLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.white10), bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          _ChartBar(height: 0.2),
          _ChartBar(height: 0.4),
          _ChartBar(height: 0.35),
          _ChartBar(height: 0.6),
          _ChartBar(height: 0.55),
          _ChartBar(height: 0.8),
          _ChartBar(height: 0.95),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double height;
  const _ChartBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: height,
      child: Container(
        width: 4,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 10)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FauxDonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: CircularProgressIndicator(
            value: 0.7,
            strokeWidth: 20,
            backgroundColor: AppColors.surfaceContainer,
            color: AppColors.primaryContainer,
          ),
        ),
        const Text('Assault', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final String label;
  final Color color;
  const _ChartLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

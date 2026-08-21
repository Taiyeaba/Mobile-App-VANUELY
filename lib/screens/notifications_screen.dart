import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Booking Confirmed 🎉',
      body: 'Your venue booking at The Grand Garden Palace has been verified by the host.',
      time: '10 mins ago',
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Special Discount 🏷️',
      body: 'Get 15% instant deposit discount on all weekend bookings this month.',
      time: '2 hours ago',
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Reminder 🗓️',
      body: 'Your upcoming event at Skyline Rooftop is scheduled for next week.',
      time: 'Yesterday',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications ${unreadCount > 0 ? "($unreadCount)" : ""}'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var n in _notifications) {
                    n.isRead = true;
                  }
                });
              },
              child: const Text('Mark All Read', style: TextStyle(color: AppColors.gold)),
            ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? Center(
                child: Text('No Notifications', style: TextStyle(color: textSecondary)),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        notif.isRead = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: notif.isRead ? cardBg : AppColors.gold.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: notif.isRead ? border : AppColors.gold),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_active_rounded, color: Colors.black, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notif.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(notif.time, style: TextStyle(fontSize: 10, color: textSecondary)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.body,
                                  style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          if (!notif.isRead) ...[
                            const SizedBox(width: 8),
                            const CircleAvatar(radius: 4, backgroundColor: AppColors.gold),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

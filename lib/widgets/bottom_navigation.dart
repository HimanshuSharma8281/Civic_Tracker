import 'package:flutter/material.dart';
import '../models/models.dart';

class CustomBottomNavigation extends StatelessWidget {
  final AppScreen activeScreen;
  final Function(AppScreen) onNavigate;
  final int unreadNotifications;

  const CustomBottomNavigation({
    Key? key,
    required this.activeScreen,
    required this.onNavigate,
    required this.unreadNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                screen: AppScreen.home,
                isActive: activeScreen == AppScreen.home,
              ),
              _buildNavItem(
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'Reports',
                screen: AppScreen.history,
                isActive: activeScreen == AppScreen.history,
              ),
              _buildNavItem(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
                label: 'Alerts',
                screen: AppScreen.notifications,
                isActive: activeScreen == AppScreen.notifications,
                badgeCount: unreadNotifications,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                screen: AppScreen.profile,
                isActive: activeScreen == AppScreen.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required AppScreen screen,
    required bool isActive,
    int? badgeCount,
  }) {
    return GestureDetector(
      onTap: () => onNavigate(screen),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 24,
                  color: isActive ? Colors.blue[600] : Colors.grey[600],
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.blue[600] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
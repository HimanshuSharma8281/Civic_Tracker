import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class CustomBottomNavigation extends StatefulWidget {
  final AppScreen activeScreen;
  final Function(AppScreen) onNavigate;
  final int unreadNotifications;

  const CustomBottomNavigation({
    Key? key,
    required this.activeScreen,
    required this.onNavigate,
    this.unreadNotifications = 0,
  }) : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _badgeController;
  late AnimationController _fabController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _badgeAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _badgeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _badgeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.bounceOut),
    );
    _fabAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    if (widget.unreadNotifications > 0) {
      _badgeController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.unreadNotifications > 0 && oldWidget.unreadNotifications == 0) {
      _badgeController.forward();
    } else if (widget.unreadNotifications == 0 &&
        oldWidget.unreadNotifications > 0) {
      _badgeController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _badgeController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onTabTapped(AppScreen screen) {
    HapticFeedback.selectionClick();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onNavigate(screen);
  }

  void _onReportTapped() {
    HapticFeedback.mediumImpact();
    _fabController.forward().then((_) {
      _fabController.reverse();
    });
    widget.onNavigate(AppScreen.report);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: _getCurrentIndex(),
              onTap: (index) => _onTabTapped(_getScreenFromIndex(index)),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Color(0xFF2196F3),
              unselectedItemColor: Color(0xFF9E9E9E),
              selectedFontSize: 12,
              unselectedFontSize: 10,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildAnimatedIcon(
                    Icons.home_outlined,
                    Icons.home,
                    AppScreen.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildAnimatedIcon(
                    Icons.history_outlined,
                    Icons.history,
                    AppScreen.history,
                  ),
                  label: 'My Reports',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox(
                      width: 24, height: 24), // Placeholder for FAB space
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _buildNotificationIcon(),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: _buildAnimatedIcon(
                    Icons.person_outline,
                    Icons.person,
                    AppScreen.profile,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button for Report
        Positioned(
          top: -25,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: AnimatedBuilder(
            animation: _fabAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _fabAnimation.value,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2196F3).withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _onReportTapped,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_box,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Report label
        Positioned(
          top: 45,
          left: MediaQuery.of(context).size.width / 2 - 20,
          child: Text(
            'Report',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: widget.activeScreen == AppScreen.report
                  ? Color(0xFF2196F3)
                  : Color(0xFF9E9E9E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedIcon(
      IconData outlinedIcon, IconData filledIcon, AppScreen screen) {
    bool isActive = widget.activeScreen == screen;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? _scaleAnimation.value : 1.0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? Color(0xFF2196F3).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? filledIcon : outlinedIcon,
              size: 24,
              color: isActive ? Color(0xFF2196F3) : Color(0xFF9E9E9E),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationIcon() {
    bool isActive = widget.activeScreen == AppScreen.notifications;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? _scaleAnimation.value : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Color(0xFF2196F3).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? Icons.notifications : Icons.notifications_outlined,
                  size: 24,
                  color: isActive ? Color(0xFF2196F3) : Color(0xFF9E9E9E),
                ),
              ),
              if (widget.unreadNotifications > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: AnimatedBuilder(
                    animation: _badgeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _badgeAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF5722),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF5722).withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            widget.unreadNotifications > 99
                                ? '99+'
                                : widget.unreadNotifications.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  int _getCurrentIndex() {
    switch (widget.activeScreen) {
      case AppScreen.home:
        return 0;
      case AppScreen.history:
        return 1;
      case AppScreen.notifications:
        return 3;
      case AppScreen.profile:
        return 4;
      default:
        return 0;
    }
  }

  AppScreen _getScreenFromIndex(int index) {
    switch (index) {
      case 0:
        return AppScreen.home;
      case 1:
        return AppScreen.history;
      case 3:
        return AppScreen.notifications;
      case 4:
        return AppScreen.profile;
      default:
        return AppScreen.home;
    }
  }
}

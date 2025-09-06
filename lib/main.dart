import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/history_screen.dart';
import 'screens/report_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'widgets/bottom_navigation.dart';
import 'data/mock_data.dart';
import 'models/models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicReport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  AppScreen _currentScreen = AppScreen.splash;
  bool _isAuthenticated = false;
  String _selectedReportId = '';

  @override
  void initState() {
    super.initState();
    // Show splash screen for 3 seconds
    if (_currentScreen == AppScreen.splash) {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _currentScreen = AppScreen.login;
        });
      });
    }
  }

  void _handleAuth() {
    setState(() {
      _isAuthenticated = true;
      _currentScreen = AppScreen.home;
    });
  }

  void _handleLogout() {
    setState(() {
      _isAuthenticated = false;
      _currentScreen = AppScreen.login;
    });
  }

  void _handleNavigation(AppScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _handleReportSubmit() {
    setState(() {
      _currentScreen = AppScreen.confirmation;
    });
  }

  void _handleReportClick(String reportId) {
    setState(() {
      _selectedReportId = reportId;
      _currentScreen = AppScreen.detail;
    });
  }

  void _handleNotificationClick([String? reportId]) {
    if (reportId != null) {
      setState(() {
        _selectedReportId = reportId;
        _currentScreen = AppScreen.detail;
      });
    }
  }

  int get _unreadCount => mockNotifications.where((n) => !n.read).length;

  Widget _renderScreen() {
    switch (_currentScreen) {
      case AppScreen.splash:
        return SplashScreen(onContinue: () => _handleNavigation(AppScreen.login));
      case AppScreen.login:
        return LoginScreen(
          onLogin: _handleAuth,
          onSwitchToRegister: () => _handleNavigation(AppScreen.register),
        );
      case AppScreen.register:
        return RegisterScreen(
          onRegister: _handleAuth,
          onSwitchToLogin: () => _handleNavigation(AppScreen.login),
        );
      case AppScreen.home:
        return HomeScreen(onNavigate: _handleNavigation);
      case AppScreen.report:
        return ReportScreen(
          onSubmit: _handleReportSubmit,
          onBack: () => _handleNavigation(AppScreen.home),
        );
      case AppScreen.confirmation:
        return ConfirmationScreen(
          onGoHome: () => _handleNavigation(AppScreen.home),
          onViewReports: () => _handleNavigation(AppScreen.history),
        );
      case AppScreen.history:
        return HistoryScreen(onReportClick: _handleReportClick);
      case AppScreen.detail:
        return ReportDetailScreen(
          reportId: _selectedReportId,
          onBack: () => _handleNavigation(AppScreen.history),
        );
      case AppScreen.profile:
        return ProfileScreen(onLogout: _handleLogout);
      case AppScreen.notifications:
        return NotificationsScreen(onNotificationClick: _handleNotificationClick);
      default:
        return HomeScreen(onNavigate: _handleNavigation);
    }
  }

  bool get _showBottomNav => 
    _isAuthenticated && 
    ![AppScreen.report, AppScreen.confirmation, AppScreen.detail].contains(_currentScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _renderScreen(),
      bottomNavigationBar: _showBottomNav
          ? CustomBottomNavigation(
              activeScreen: _currentScreen,
              onNavigate: _handleNavigation,
              unreadNotifications: _unreadCount,
            )
          : null,
    );
  }
}
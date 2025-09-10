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
import 'screens/asset_test_screen.dart';
import 'widgets/bottom_navigation.dart';
import 'data/mock_data.dart';
import 'models/models.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicReport',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2196F3),
          brightness: Brightness.light,
          primary: Color(0xFF2196F3),
          onPrimary: Colors.white,
          secondary: Color(0xFF1976D2),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Color(0xFFF8F9FA),
          onBackground: Colors.black,
        ),
        fontFamily: 'Inter',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Color(0xFF2196F3).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF2196F3),
            side: BorderSide(color: Color(0xFF2196F3), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: Color(0xFF2196F3),
          secondarySelectedColor: Color(0xFF2196F3),
          labelStyle: TextStyle(color: Color(0xFF2196F3)),
          secondaryLabelStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Color(0xFF2196F3)),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: CircleBorder(),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF2196F3),
          unselectedItemColor: Color(0xFF9E9E9E),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
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
        return SplashScreen(
            onContinue: () => _handleNavigation(AppScreen.login));
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
        return NotificationsScreen(
            onNotificationClick: _handleNotificationClick);
    }
  }

  bool get _showBottomNav =>
      _isAuthenticated &&
      ![AppScreen.confirmation, AppScreen.detail].contains(_currentScreen);

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

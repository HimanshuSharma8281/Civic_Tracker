import 'dart:io';

void main() {
  print('🚀 Setting up CivicReport assets folder structure...\n');

  try {
    // Create assets folder
    final assetsDir = Directory('assets');
    if (!assetsDir.existsSync()) {
      assetsDir.createSync();
      print('✅ Created assets/ folder');
    } else {
      print('✅ assets/ folder already exists');
    }

    // Create icons folder
    final iconsDir = Directory('assets/icons');
    if (!iconsDir.existsSync()) {
      iconsDir.createSync(recursive: true);
      print('✅ Created assets/icons/ folder');
    } else {
      print('✅ assets/icons/ folder already exists');
    }

    // Create images folder
    final imagesDir = Directory('assets/images');
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
      print('✅ Created assets/images/ folder');
    } else {
      print('✅ assets/images/ folder already exists');
    }

    print('\n📋 Next Steps:');
    print('1. Copy your PNG files to assets/icons/ with these exact names:');
    print('   • google_icon.png');
    print('   • facebook_icon.png');
    print('   • twitter_icon.png');
    print('');
    print('2. Update pubspec.yaml to uncomment the assets section');
    print('');
    print('3. Run: flutter pub get');
    print('');
    print('4. Run: flutter run');

    // Check current status of icon files
    print('\n🔍 Current status:');
    final requiredIcons = [
      'google_icon.png',
      'facebook_icon.png',
      'twitter_icon.png'
    ];

    for (String iconName in requiredIcons) {
      final iconFile = File('assets/icons/$iconName');
      if (iconFile.existsSync()) {
        print('✅ $iconName - Found');
      } else {
        print('❌ $iconName - Missing (add this file)');
      }
    }
  } catch (e) {
    print('❌ Error creating directories: $e');
    exit(1);
  }
}

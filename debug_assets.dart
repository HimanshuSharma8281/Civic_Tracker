import 'dart:io';

void main() {
  print('🔍 Debugging CivicReport assets...\n');

  // Check current working directory
  print('📁 Current directory: ${Directory.current.path}');

  // Check if assets folder exists
  final assetsDir = Directory('assets');
  print('\n📂 Assets folder check:');
  if (assetsDir.existsSync()) {
    print('✅ assets/ folder exists');

    // List all contents in assets folder
    try {
      final contents = assetsDir.listSync();
      if (contents.isEmpty) {
        print('⚠️  assets/ folder is empty');
      } else {
        print('📋 Contents of assets/:');
        for (var item in contents) {
          print('  - ${item.path.split(Platform.pathSeparator).last}');
        }
      }
    } catch (e) {
      print('❌ Error reading assets folder: $e');
    }
  } else {
    print('❌ assets/ folder does not exist');
    print('Creating assets folder...');
    assetsDir.createSync();
    print('✅ Created assets/ folder');
  }

  // Check icons folder
  final iconsDir = Directory('assets/icons');
  print('\n🎨 Icons folder check:');
  if (iconsDir.existsSync()) {
    print('✅ assets/icons/ folder exists');

    // List all files in icons folder
    try {
      final iconFiles = iconsDir.listSync();
      if (iconFiles.isEmpty) {
        print('⚠️  assets/icons/ folder is empty');
      } else {
        print('📋 Files in assets/icons/:');
        for (var file in iconFiles) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          final fileSize = file is File ? file.lengthSync() : 0;
          print('  - $fileName (${fileSize} bytes)');
        }
      }
    } catch (e) {
      print('❌ Error reading icons folder: $e');
    }
  } else {
    print('❌ assets/icons/ folder does not exist');
    print('Creating icons folder...');
    iconsDir.createSync(recursive: true);
    print('✅ Created icons/icons/ folder');
  }

  // Check specific required files
  print('\n🔍 Required icon files check:');
  final requiredIcons = [
    'google_icon.png',
    'facebook_icon.png',
    'twitter_icon.png'
  ];

  bool allIconsPresent = true;
  for (String iconName in requiredIcons) {
    final iconFile = File('assets/icons/$iconName');
    if (iconFile.existsSync()) {
      final size = iconFile.lengthSync();
      print('✅ $iconName - Found (${size} bytes)');
      if (size == 0) {
        print('   ⚠️  Warning: File is empty (0 bytes)');
        allIconsPresent = false;
      }
    } else {
      print('❌ $iconName - Missing');
      allIconsPresent = false;
    }
  }

  // Check pubspec.yaml assets configuration
  print('\n📄 Pubspec.yaml check:');
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final content = pubspecFile.readAsStringSync();
    if (content.contains('assets:') && content.contains('- assets/icons/')) {
      print('✅ pubspec.yaml has assets configuration');
    } else {
      print('❌ pubspec.yaml missing assets configuration');
    }
  } else {
    print('❌ pubspec.yaml not found');
  }

  print('\n🚀 Troubleshooting steps:');
  if (!allIconsPresent) {
    print('1. ❌ Add missing PNG files to assets/icons/');
    print('2. 🔄 Run: flutter pub get');
    print('3. 🧹 Run: flutter clean');
    print('4. ▶️  Run: flutter run');
  } else {
    print('1. ✅ All files present!');
    print('2. 🔄 Run: flutter pub get');
    print('3. 🧹 Run: flutter clean');
    print('4. ▶️  Run: flutter run');
    print('\n💡 If images still don\'t show:');
    print('   - Try hot restart (Ctrl+Shift+F5) not hot reload');
    print(
        '   - Check file names are exactly: google_icon.png, facebook_icon.png, twitter_icon.png');
    print('   - Verify PNG files are valid images (not corrupted)');
    print('   - Make sure files are not 0 bytes');
  }
}

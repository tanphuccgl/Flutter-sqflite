
clean: 
	@echo "$ Cleaning the project"
	@rm -rf pubspec.lock
	@rm -rf ./ios/Podfile.lock
	@flutter clean && flutter pub get && make pod
get:
	@flutter pub get
format:
	@dart format .
lint:
	@dart analyze
install:
	@flutter install
runnerForce: 
	@flutter packages pub run build_runner build --delete-conflicting-outputs
runner:	
	@flutter packages pub run build_runner build
pod:
	@pod install --project-directory=ios && pod update --project-directory=ios
signingReport:
	@cd android && ./gradlew signingReport && cd ..
# keytool -list -v -keystore android/app/release-keystore.jks -alias <key alias>
staging:
	@cp ./assets/config/.env.staging ./assets/config/.env 
	@cp ./lib/src/firebase_options_staging.dart ./lib/firebase_options.dart
	@firebase use wile-staging 
# android
	@cp ./android/app/build-staging.gradle ./android/app/build.gradle
	@cp ./android/app/src/main/AndroidManifestStaging.xml ./android/app/src/main/AndroidManifest.xml
	@cp ./android/app/src/main/value/MainActivityStaging.kt ./android/app/src/main/kotlin/com/example/my_app/MainActivity.kt
	@cp ./android/app/src/profile/AndroidManifestStaging.xml ./android/app/src/profile/AndroidManifest.xml
	@cp ./android/app/src/debug/AndroidManifestStaging.xml ./android/app/src/debug/AndroidManifest.xml
# iOS
	@cp ./ios/Runner/InfoStaging.plist ./ios/Runner/Info.plist
	@cp ./ios/Runner/RunnerStaging.entitlements ./ios/Runner/Runner.entitlements
	@cp ./ios/Runner.xcodeproj/projectstaging.pbxproj ./ios/Runner.xcodeproj/project.pbxproj
# Website
	@cp ./web/firebase-messaging-sw.staging.js ./web/firebase-messaging-sw.js
# Functions
	@cp ./functions/.env.staging ./functions/.env 
	@cp ./functions/package-staging.json ./functions/package.json 
	
production:
	@cp ./assets/config/.env.production ./assets/config/.env 
	@cp ./lib/src/firebase_options_production.dart ./lib/firebase_options.dart
	@firebase use wile-chat  
# android
	@cp ./android/app/build-production.gradle ./android/app/build.gradle
	@cp ./android/app/src/main/AndroidManifestProduction.xml ./android/app/src/main/AndroidManifest.xml
	@cp ./android/app/src/main/value/MainActivityProduction.kt ./android/app/src/main/kotlin/com/example/my_app/MainActivity.kt
	@cp ./android/app/src/profile/AndroidManifestProduction.xml ./android/app/src/profile/AndroidManifest.xml
	@cp ./android/app/src/debug/AndroidManifestProduction.xml ./android/app/src/debug/AndroidManifest.xml
# iOS
	@cp ./ios/Runner/InfoProduction.plist ./ios/Runner/Info.plist
	@cp ./ios/Runner/RunnerProduction.entitlements ./ios/Runner/Runner.entitlements
	@cp ./ios/Runner.xcodeproj/projectproduction.pbxproj ./ios/Runner.xcodeproj/project.pbxproj
# Website
	@cp ./web/firebase-messaging-sw.production.js ./web/firebase-messaging-sw.js
# Functions
	@cp ./functions/.env.production ./functions/.env 
	@cp ./functions/package-production.json ./functions/package.json 



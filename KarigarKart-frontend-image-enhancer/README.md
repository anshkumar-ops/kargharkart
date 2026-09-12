# KarigarKart

A Flutter + Dart artisan marketplace demo with a real AI product-image flow. Camera/gallery selection sends the chosen image to the KarigarKart backend, which removes the background, corrects lighting and returns a 1200 x 1200 marketplace JPEG.

## Run in Android Studio

1. Open this project folder (the folder containing `pubspec.yaml`) in Android Studio with the Flutter plugin enabled.
2. Start the KarigarKart FastAPI backend on port 8000.
3. Select an Android emulator.
4. Run `flutter pub get`, then execute `flutter run` in the project root.

The app entry point is `lib/main.dart`.

The emulator uses `http://10.0.2.2:8000` by default. For a physical phone on the same Wi-Fi as the backend laptop, run:

```powershell
flutter run --dart-define=API_BASE_URL=http://LAPTOP_IPV4:8000
```

## Image demo flow

Login with any email/phone and a 4-character password, then open **AI Image Studio**. Take or choose a photo, wait for the real backend enhancement, compare original and enhanced images, accept the result, add the product details and publish it to the local demo catalog.

The first enhancement may take longer while the backend downloads or loads the rembg model. Android cleartext HTTP is enabled only for this local SIH prototype.

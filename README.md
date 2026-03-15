# Flutter Vertical Onboarding Animation

A Flutter project demonstrating a beautiful, engaging vertical onboarding flow with custom scroll physics, staggered text animations, and dynamic backgrounds.

## Features

- **Vertical PageView:** A smooth vertical scrolling experience for onboarding steps.
- **Custom Scroll Physics:** Uses `SinglePageScrollPhysics` to ensure users always snap to exactly one page at a time (preventing continuous scrolling).
- **Staggered Animations:** Complex UI transitions using `AnimationController` and `AnimatedBuilder`. As the user scrolls to a page, the question text shrinks and moves upward, while the answer text fades and slides in from exactly the right side.
- **State Management:** Uses Riverpod to track the current page index efficiently.
- **Responsive Design:** Automatically adjusts to different screen sizes to maintain a visually appealing layout.

## Screenshots / Video
*(Consider adding a GIF or MP4 here to showcase the beautiful staggered animations!)*

## Getting Started

To run this project on your local machine:

1. Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install).
2. Clone this repository or download the source code.
3. Open a terminal in the project directory.
4. Run the following command to fetch dependencies:
   ```bash
   flutter pub get
   ```
5. Run the application:
   ```bash
   flutter run
   ```

## Standalone Dart Program
This project also includes a standalone Dart program in the `bin/` directory. 
To run the Dart program, navigate to the root of the project and execute the following command:
```bash
dart run bin/dart_program.dart
```

## Dependencies used
* [flutter_riverpod](https://pub.dev/packages/flutter_riverpod): For robust state management across onboarding steps.

## Architecture

* **main.dart**: Entry point that wraps the app with a `ProviderScope` and loads the `VerticalOnboardingScreen`.
* **onboarding_screen.dart**: Contains the main screen, the `PageView` with custom physics, and the `AnimatedPage` which handles the complex text fading and sliding logic when users reach a specific step.

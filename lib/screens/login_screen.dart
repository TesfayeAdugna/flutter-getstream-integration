// 🎯 Dart imports:
import 'dart:async';
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/app/user_auth_controller.dart';
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/widgets/stream_button.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../di/injector.dart';
import '../utils/assets.dart';
import '../utils/loading_dialog.dart';
import '../widgets/environment_switcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _appPreferences = locator<AppPreferences>();
  final _emailController = TextEditingController();

  Future<void> _loginWithGoogle() async {
    final googleService = locator<GoogleSignIn>();

    final googleUser = await googleService.signIn();
    if (googleUser == null) return debugPrint('Google login cancelled');

    final userInfo = UserInfo(
      role: 'admin',
      id: googleUser.email,
      name: googleUser.displayName ?? '',
      image: googleUser.photoUrl,
    );

    return _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text;
    if (email.isEmpty) return debugPrint('Email is empty');

    final userInfo = UserInfo(
      role: 'admin',
      id: email.replaceAll('@', '_').replaceAll('.', '_'),
      name: email,
    );

    return _login(User(info: userInfo), _appPreferences.environment);
  }

  Future<void> _loginAsGuest() async {
    final userId = randomId(size: 6);
    final userInfo = UserInfo(
      role: 'admin',
      id: userId,
      name: userId,
      image:
          'https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg',
    );

    return _login(User(info: userInfo, type: UserType.guest),
        _appPreferences.environment);
  }

  Future<void> _login(User user, Environment environment) async {
    if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();
    await authController.login(user, environment);

    if (mounted) hideLoadingIndicator(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
   


  // Print the current environment to the console
  print('Current Environment: ${_appPreferences.environment.name}');


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorPalette.backgroundColor,
        actions: [
          EnvironmentSwitcher(
            currentEnvironment: _appPreferences.environment,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
              image: AssetImage('assets/splash.png'),
              width: 200, // Set your desired width
              height: 200, // Set your desired height
            ),
                // Hero(
                //   tag: 'stream_logo',
                //   child: Image.asset(
                //     streamVideoIconAsset,
                //     width: size.width * 0.8,
                //   ),
                // ),
                // const SizedBox(height: 36),
                // Text('Stream', style: theme.textTheme.headlineMedium),
                Text(
                  'Sign up to continue',
                  style: theme.textTheme.headlineMedium?.apply(
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: TextField(
    controller: _emailController,
    style: theme.textTheme.bodyMedium?.apply(
      color: Color.fromARGB(255, 67, 31, 62),
    ),
    decoration: InputDecoration(
      labelText: 'Enter Email',
      labelStyle: TextStyle(color: Color.fromARGB(255, 70, 16, 79)), // Set label color to purple
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 70, 16, 79)), // Set border color to purple
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 70, 16, 79)), // Set border color to purple when focused
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 70, 16, 79)), // Set border color to purple when enabled
      ),
    ),
  ),
),

                const SizedBox(height: 16),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    width: double.infinity, // Set the width to the desired value, or use specific value like 300
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5), // Set border radius here
      color: Color.fromARGB(255, 70, 16, 79), // Background color
    ),
    child: ElevatedButton.icon(
      onPressed: _loginWithEmail,
      icon: const Icon(
        Icons.email_outlined,
        color: Colors.white, // Icon color
      ),
      label: const Text('Sign up with email'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.purple, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Ensure the button's shape matches the container
        ),
        padding: EdgeInsets.symmetric(vertical: 16), // Optional: adjust padding
      ),
    ),
  ),
),


                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 8),
                      //   child: Text('OR'),
                      // ),
                      // Expanded(
                      //   child: Container(
                      //     height: 1,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: GoogleLoginButton(
                //     onPressed: _loginWithGoogle,
                //   ),
                // ),
                // const SizedBox(height: 16),
                // // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: StreamButton.tertiary(
                //     onPressed: _loginAsGuest,
                //     label: 'Join As Guest',
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({
    super.key,
    required this.onPressed,
    this.label = 'Login with Google',
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Google SignIn plugin is only supported on Web, Android and iOS.
    final isGoogleSignInSupported =
        defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android ||
            kIsWeb;

    final currentPlatform = Theme.of(context).platform.name;

    if (!isGoogleSignInSupported) {
      return Text('Google SignIn is not supported on $currentPlatform.');
    }

    return StreamButton.primary(
      onPressed: onPressed,
      label: 'Continue with Google',
      icon: SvgPicture.asset(
        googleLogoAsset,
        width: 24,
        semanticsLabel: 'Google Logo',
      ),
    );
  }
}

// This alphabet uses `A-Za-z0-9_-` symbols. The genetic algorithm helped
// optimize the gzip compression for this alphabet.
const _alphabet =
    'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}

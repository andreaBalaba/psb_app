import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psb_app/api/services/add_user.dart';
import 'package:psb_app/api/services/add_weekly.dart';
import 'package:psb_app/features/assessment/screen/get_started_page.dart';
import 'package:psb_app/features/authentication/screen/signup_page.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/textfield_widget.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode(); // FocusNode for email field
  final FocusNode _passwordFocusNode =
      FocusNode(); // FocusNode for password field
  bool _isPasswordVisible = false; // State variable for password visibility

  double get autoScale => Get.width / 360; // Responsive scaling factor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pWhiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * autoScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40 * autoScale),
                _buildLogo(),
                SizedBox(height: 40 * autoScale),
                _buildTextField(
                  hintText: 'Email',
                  isPasswordField: false,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  nextFocusNode:
                      _passwordFocusNode, // Move to password on 'Next'
                ),
                SizedBox(height: 25 * autoScale),
                _buildTextField(
                  hintText: 'Password',
                  isPasswordField: true,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          final formKey = GlobalKey<FormState>();
                          final TextEditingController emailController =
                              TextEditingController();

                          return AlertDialog(
                            backgroundColor: Colors.grey[300],
                            title: const ReusableText(
                              text: 'Forgot Password',
                              color: Colors.black,
                            ),
                            content: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFieldWidget(
                                    width: 300,
                                    hintColor: Colors.black,
                                    radius: 10,
                                    color: Colors.black,
                                    borderColor: Colors.black,
                                    hint: 'Email',
                                    textCapitalization: TextCapitalization.none,
                                    inputType: TextInputType.emailAddress,
                                    label: 'Email',
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email address';
                                      }
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: (() {
                                  Navigator.pop(context);
                                }),
                                child: const ReusableText(
                                  text: 'Cancel',
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: (() async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      Navigator.pop(context);
                                      await FirebaseAuth.instance
                                          .sendPasswordResetEmail(
                                              email: emailController.text);
                                      // showToast(
                                      //     'Password reset link sent to ${emailController.text}');
                                    } catch (e) {
                                      String errorMessage = '';

                                      if (e is FirebaseException) {
                                        switch (e.code) {
                                          case 'invalid-email':
                                            errorMessage =
                                                'The email address is invalid.';
                                            break;
                                          case 'user-not-found':
                                            errorMessage =
                                                'The user associated with the email address is not found.';
                                            break;
                                          default:
                                            errorMessage =
                                                'An error occurred while resetting the password.';
                                        }
                                      } else {
                                        errorMessage =
                                            'An error occurred while resetting the password.';
                                      }

                                      Navigator.pop(context);
                                    }
                                  }
                                }),
                                child: const ReusableText(
                                  text: 'Continue',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    },
                    child: const ReusableText(
                        text: 'Forgot Password?', color: Colors.black),
                  ),
                ),
                SizedBox(height: 20 * autoScale),
                _buildContinueDivider(),
                SizedBox(height: 20 * autoScale),
                _buildGoogleButton(),
                SizedBox(height: 30 * autoScale),
                _buildSignUpText(),
                SizedBox(height: 30 * autoScale),
                _buildLoginButton(),
                SizedBox(height: 30 * autoScale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 180 * autoScale,
      height: 180 * 0.75 * autoScale,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.asset(ImageAssets.pLogo),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isPasswordField,
    required TextEditingController controller,
    FocusNode? focusNode, // Add focusNode parameter
    FocusNode? nextFocusNode, // Add nextFocusNode for chaining focus
  }) {
    return Container(
      height: 50 * autoScale,
      decoration: BoxDecoration(
        color: AppColors.pTFColor,
        borderRadius: BorderRadius.circular(18.0 * autoScale),
        boxShadow: [
          BoxShadow(
            color: AppColors.pGrey400Color,
            spreadRadius: -1,
            blurRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode, // Set focusNode
        obscureText: isPasswordField && !_isPasswordVisible,
        style: TextStyle(
          color: AppColors.pBlackColor,
          fontFamily: 'Poppins',
          fontSize: 14 * autoScale,
        ),
        cursorColor: AppColors.pGrey800Color,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: isPasswordField
            ? TextInputAction.done
            : TextInputAction.next, // Set input action
        onSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context)
                .requestFocus(nextFocusNode); // Move focus to the next field
          }
        },
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15 * autoScale),
          hintText: hintText,
          hintStyle: TextStyle(
              color: AppColors.pDarkGreyColor,
              fontFamily: 'Poppins',
              fontSize: 14 * autoScale),
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.pGrey800Color,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildContinueDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(thickness: 1, color: AppColors.pBlackColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8 * autoScale),
          child: ReusableText(
            text: "Continue with",
            size: 12 * autoScale,
          ),
        ),
        const Expanded(
            child: Divider(thickness: 1, color: AppColors.pBlackColor)),
      ],
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> registerWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign in cancelled.')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user is new
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          // New user: add to Firestore and navigate to get started
          await addUser(user.displayName ?? 'Unknown User', user.email ?? '');
          addWeekly();

          Get.offAll(() => const GetStarted(), transition: Transition.noTransition);
        } else {
          // Existing user: navigate to home
          Get.offAll(() => const HomePage(), transition: Transition.noTransition);
        }
      }
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            errorMessage = 'An account already exists with this email.';
            break;
          case 'invalid-credential':
            errorMessage = 'The credentials are invalid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Google sign-in is not enabled.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No account found with this email.';
            break;
          default:
            errorMessage = 'Sign in failed. Please try again.';
        }
      } else {
        errorMessage = 'An unexpected error occurred.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage))
      );
    }
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity, // Full width to match the TextField width
      height: 50 * autoScale,
      child: ElevatedButton.icon(
        onPressed: () {
          // Google sign-in logic here
          registerWithGoogle(context);
        },
        icon: Image.asset(
          IconAssets.pGoogleIcon,
          height: 33 * autoScale,
          width: 33 * autoScale,
        ),
        label: ReusableText(
          text: "Google",
          color: AppColors.pBlackColor,
          fontWeight: FontWeight.w500,
          size: 14 * autoScale,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pTFColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18 * autoScale),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return RichText(
      text: TextSpan(
        text: "Don’t have an account yet? ",
        style: TextStyle(
            color: AppColors.pDarkGreyColor,
            fontSize: 12 * autoScale,
            fontFamily: 'Poppins'),
        children: [
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: AppColors.pSOrangeColor,
              fontSize: 12 * autoScale,
              fontFamily: 'Poppins',
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => const SignUpPage()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 150 * autoScale,
      height: 50 * autoScale,
      child: ElevatedButton(
        onPressed: () {
          login(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pTFColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18 * autoScale)),
        ),
        child: ReusableText(
          text: "Log in",
          color: AppColors.pDarkGreyColor,
          fontWeight: FontWeight.w500,
          size: 14 * autoScale,
        ),
      ),
    );
  }

  login(context) async {
    // First validate inputs
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      Get.offAll(() => const HomePage(),
          transition: Transition.noTransition);

    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'wrong-password':
        case 'user-not-found':
        // Group common authentication failures under one user-friendly message
          errorMessage = 'Incorrect email or password.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }
}

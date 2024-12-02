import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psb_app/api/services/add_user.dart';
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
      // Attempt to sign in the user with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the Google sign-in
        return;
      }

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user is new or existing
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          // New user: add additional user info to Firestore

          addUser(user.displayName ?? 'Unknown User', user.email ?? '');

          // Optionally, navigate to a welcome or setup page for new users
        }

        Get.offAll(() => const HomePage(),
            transition: Transition.noTransition); //temporary
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication error")),
      );
    } on Exception catch (e) {
      // Handle general errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      Get.offAll(() => const HomePage(),
          transition: Transition.noTransition); //temporary
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

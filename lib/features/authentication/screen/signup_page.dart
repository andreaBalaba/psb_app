import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psb_app/api/services/add_user.dart';
import 'package:psb_app/api/services/add_weekly.dart';
import 'package:psb_app/features/assessment/screen/get_started_page.dart';
import 'package:psb_app/features/authentication/screen/legal%20docs/privacy_policy.dart';
import 'package:psb_app/features/authentication/screen/legal%20docs/terms_and_condition.dart';
import 'package:psb_app/features/authentication/screen/login_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;
  late bool _passwordsMatch = true;
  bool _hasTypedInConfirmPassword = false;

  double get autoScale => Get.width / 360;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch = _passwordController.text ==
          _confirmPasswordController.text;
      _hasTypedInConfirmPassword = _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * autoScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40 * autoScale),
                ReusableText(
                  text: "SIGN UP",
                  size: 24 * autoScale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.pDarkGreyColor,
                ),
                const SizedBox(height: 30),
                _buildTextField("Name", _usernameController, false,
                    _usernameFocusNode, _emailFocusNode),
                SizedBox(height: 25 * autoScale),
                _buildTextField("Email Address", _emailController, false,
                    _emailFocusNode, _passwordFocusNode),
                SizedBox(height: 25 * autoScale),
                _buildTextField("Password", _passwordController, true,
                    _passwordFocusNode, _confirmPasswordFocusNode),
                SizedBox(height: 25 * autoScale),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Confirm Password",
                        _confirmPasswordController, true, _confirmPasswordFocusNode, null),
                    if (_hasTypedInConfirmPassword)
                      Padding(
                        padding: EdgeInsets.only(top: 8 * autoScale),
                        child: ReusableText(
                          text: _passwordsMatch
                              ? 'Passwords match'
                              : 'Passwords do not match',
                          color: _passwordsMatch
                              ? AppColors.pGreenColor
                              : AppColors.pSOrangeColor,
                          size: 12 * autoScale,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20 * autoScale),
                _buildContinueDivider(),
                SizedBox(height: 20 * autoScale),
                _buildGoogleButton(),
                SizedBox(height: 25 * autoScale),
                _buildTermsCheckbox(),
                SizedBox(height: 30 * autoScale),
                _buildLoginText(),
                SizedBox(height: 30 * autoScale),
                _buildSignUpButton(),
                SizedBox(height: 30 * autoScale),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText,
      TextEditingController controller,
      bool isPasswordField,
      FocusNode currentFocusNode,
      FocusNode? nextFocusNode) {
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
        focusNode: currentFocusNode,
        obscureText: isPasswordField && !_isPasswordVisible,
        textInputAction:
        nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        style: TextStyle(
          color: AppColors.pBlackColor,
          fontFamily: 'Poppins',
          fontSize: 14 * autoScale,
        ),
        cursorColor: AppColors.pGrey800Color,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15 * autoScale),
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.pDarkGreyColor,
            fontSize: 14 * autoScale,
            fontFamily: 'Poppins',
          ),
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
    // First check terms and conditions
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Conditions to continue.'),
        ),
      );
      return;
    }

    try {
      // Attempt to sign in with Google first (shows Google account picker)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check mounted before showing SnackBar
      if (!mounted) return;

      if (googleUser == null) {
        // User canceled the Google sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign in cancelled.'),
          ),
        );
        return;
      }

      // After user selects account, show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
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
          await addUser(user.displayName ?? 'Unknown User', user.email ?? '');
          addWeekly();
        }

        Navigator.pop(context); // Remove loading indicator
        Get.offAll(() => const GetStarted(),
            transition: Transition.noTransition);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Remove loading indicator
      String errorMessage = 'Something went wrong. Please try again.';

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'This email is already used with a different account';
          break;
        case 'invalid-credential':
          errorMessage = 'Unable to sign in. Please try again';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not available right now';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      Navigator.pop(context); // Remove loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again')),
      );
    }
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50 * autoScale,
      child: ElevatedButton.icon(
        onPressed: () => registerWithGoogle(context),
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

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isTermsAccepted,
          onChanged: (value) {
            setState(() {
              _isTermsAccepted = value!;
            });
          },
          activeColor: AppColors.pGreenColor,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "I agree to the ",
              style: TextStyle(
                  color: AppColors.pDarkGreyColor,
                  fontSize: 12 * autoScale,
                  fontFamily: 'Poppins'),
              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(
                    color: AppColors.pSOrangeColor,
                    fontFamily: 'Poppins',
                    fontSize: 12 * autoScale,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => const TermsAndConditionsPage());
                    },
                ),
                TextSpan(
                  text: " and ",
                  style: TextStyle(
                      fontSize: 12 * autoScale, fontFamily: 'Poppins'),
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: AppColors.pSOrangeColor,
                    fontFamily: 'Poppins',
                    fontSize: 12 * autoScale,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => const PrivacyPolicyPage());
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginText() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: TextStyle(
            color: AppColors.pDarkGreyColor,
            fontSize: 12 * autoScale,
            fontFamily: 'Poppins'),
        children: [
          TextSpan(
            text: "Login",
            style: TextStyle(
              color: AppColors.pSOrangeColor,
              fontFamily: 'Poppins',
              fontSize: 12 * autoScale,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => const LogInPage());
              },
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: 150 * autoScale,
      height: 50 * autoScale,
      child: ElevatedButton(
        onPressed: () {
          if (_isTermsAccepted) {
            if (_passwordsMatch) {
              register(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password do not match!')));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Terms and condition not accepted.')));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pTFColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18 * autoScale)),
        ),
        child: ReusableText(
          text: "Sign Up",
          color: AppColors.pDarkGreyColor,
          fontWeight: FontWeight.w500,
          size: 14 * autoScale,
        ),
      ),
    );
  }

  register(context) async {
    try {
      // Validate input fields
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty ||
          _usernameController.text.isEmpty) {
        throw Exception('Please fill in all fields');
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      addUser(_usernameController.text, _emailController.text);
      addWeekly();

      Get.offAll(() => const GetStarted(), transition: Transition.noTransition);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during registration';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }
}

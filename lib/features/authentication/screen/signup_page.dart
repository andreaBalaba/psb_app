import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/getstarted_page.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;
  final bool _passwordsMatch = true;

  double get autoScale => Get.width / 360;

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
                _buildTextField("Name", _usernameController, false, _usernameFocusNode, _emailFocusNode),
                SizedBox(height: 25 * autoScale),
                _buildTextField("Email Address", _emailController, false, _emailFocusNode, _passwordFocusNode),
                SizedBox(height: 25 * autoScale),
                _buildTextField("Password", _passwordController, true, _passwordFocusNode, _confirmPasswordFocusNode),
                SizedBox(height: 25 * autoScale),
                _buildTextField("Confirm Password", _confirmPasswordController, true, _confirmPasswordFocusNode, null),
                if (!_passwordsMatch)
                  Padding(
                    padding: EdgeInsets.only(top: 8 * autoScale),
                    child: ReusableText(
                      text: 'Passwords do not match',
                      color: AppColors.pSOrangeColor,
                      size: 12 * autoScale,
                    ),
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

  Widget _buildTextField(String hintText, TextEditingController controller, bool isPasswordField, FocusNode currentFocusNode, FocusNode? nextFocusNode) {
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
        textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
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
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
            child: Divider(
                thickness: 1,
                color: AppColors.pBlackColor
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8 * autoScale),
          child: ReusableText(
            text: "Continue with",
            size: 12 * autoScale,
          ),
        ),
        const Expanded(
            child: Divider(
                thickness: 1,
                color: AppColors.pBlackColor
            )
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50 * autoScale,
      child: ElevatedButton.icon(
        onPressed: () {
          // Google sign-in logic here
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
                      // Add Terms and Conditions logic
                    },
                ),
                TextSpan(
                  text: " and ",
                  style: TextStyle(fontSize: 12 * autoScale, fontFamily: 'Poppins'),
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
                      // Add Privacy Policy logic
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
          Get.offAll(() => GetStarted(), transition: Transition.noTransition);
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
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/auth/sign_up_page.dart';
import 'package:food_delivery/widgets/app_text_field.dart';

import '../../base/custom_loader.dart';
import '../../base/show_custom _snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    // var signUpImages = [
    //   "t.png",
    //   "f.png",
    //   "g.png",
    // ];


    void _login(AuthController authController) {
      var authController = Get.find<AuthController>();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

       if (email.isEmpty) {
        showCustomSnackBar("Type in your email address", title: "Email");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address",
            title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can't be less than 6 characters",
            title: "Password");
      } else {

        authController.login(email, password).then((status){
          if(status.isSuccess){
            Get.toNamed(RouteHelper.getInitial());
            // Get.toNamed(RouteHelper.getCartPage());
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }



    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController){
        return !authController.isLoading?SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.screenHeight * 0.05,
              ),
              //app logo
              Container(
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(
                      "assets/image/logo part 1.png",
                    ),
                  ),
                ),
              ),
              //welcome
              Container(
                margin: EdgeInsets.only(left: Dimensions.width20),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: Dimensions.font20 * 3 + Dimensions.font20 / 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Enter your email to log in or create an account.",
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              //email
              AppTextField(
                  textController: emailController,
                  hintText: "Email",
                  icon: Icons.email),
              SizedBox(
                height: Dimensions.height20,
              ),
              //password
              AppTextField(
                  textController: passwordController,
                  hintText: "Password",
                  icon: Icons.password_sharp, isObscure:true),
              SizedBox(
                height: Dimensions.height20 * 2,
              ),
              //tag line
              Row(
                children: [
                  Expanded(child: Container()),
                  RichText(
                    text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.back(),
                      text: "Sign into your account",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width20),
                ],
              ),
              SizedBox(height: Dimensions.screenHeight * 0.05),
              //sign in button
              GestureDetector(
                onTap : () {
                  _login(authController);
                },
                child: Container(
                  width: Dimensions.screenWidth / 2,
                  height: Dimensions.screenHeight / 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  child: Center(
                    child: BigText(
                        text: "Sign in",
                        size: Dimensions.font20 * 1.5,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10),

              //sign in options
              RichText(
                text: TextSpan(
                  text: "Don\'t have an account?",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: Dimensions.font20,
                  ),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => SignUpPage(), transition: Transition.fade),
                        text: " Create account",
                        style: TextStyle(
                          color: AppColors.mainBlackColor,
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              // Wrap(
              //   children: List.generate(
              //       3,
              //           (index) => Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: CircleAvatar(
              //           radius: Dimensions.radius30,
              //           backgroundImage: AssetImage(
              //             "assets/image/" + signUpImages[index],
              //           ),
              //         ),
              //       )),
              // ),
            ],
          ),
        ):CustomLoader();
      }),
    );
  }
}

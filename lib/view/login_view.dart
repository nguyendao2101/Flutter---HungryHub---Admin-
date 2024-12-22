import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungry_hub_web/view_model/login_view_model.dart';
import 'package:hungry_hub_web/widgets/common/image_extention.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginViewModel());
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Nền màu cam
            Container(
              color: Color(0xff4C585B), // Màu cam cho nền
            ),
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Form(
                      key: controller.formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 78,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _formEmail(controller),
                            const SizedBox(height: 16),
                            _formPassword(controller),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (controller.formKey.currentState
                                            ?.validate() ==
                                        true) {
                                      controller.onlogin();
                                      controller.emailController.clear();
                                      controller.passwordController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                            const SizedBox(height: 64),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Image.asset(
                        ImageAsset.loadLogoApp,
                        height: 1024,
                      ),
                    )),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _formPassword(LoginViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Obx(
        () => TextFormField(
          controller: controller.passwordController,
          obscureText: controller.isObscured.value,
          style: const TextStyle(
              color: Colors.white), // Text color to white for better visibility
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Colors.white
                    .withOpacity(0.8)), // Slightly transparent label
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Rounded border
              borderSide: BorderSide(
                  color: Colors.grey.shade400, width: 2), // Grey border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  12), // Matching rounded border when focused
              borderSide: const BorderSide(
                  color: Colors.white, width: 2), // White border when focused
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Colors.red, width: 2), // Red border when error
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2), // Red accent border when focused and error
            ),
            // filled: true,
            // fillColor: Color.fromARGB(255, 50, 50, 50)
            //     .withOpacity(0.8), // Slightly transparent dark background
            hintText: 'Password',
            hintStyle: TextStyle(
                color: Colors.white
                    .withOpacity(0.6)), // Slightly transparent hint text
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleObscureText(),
              child: Icon(
                controller.isObscured.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white
                    .withOpacity(0.8), // Icon color to match text and label
              ),
            ),
          ),
          onChanged: controller.onChangePassword,
          validator: controller.validatorPassword,
        ),
      ),
    );
  }

  Padding _formEmail(LoginViewModel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller.emailController,
        obscureText: false,
        style: const TextStyle(
            color: Colors.white), // Text color to white for better visibility
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
              color:
                  Colors.white.withOpacity(0.8)), // Slightly transparent label
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded border
            borderSide: const BorderSide(
                color: Color(0xFF77E4C8), width: 2), // Bright turquoise border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                12), // Matching rounded border when focused
            borderSide: const BorderSide(
                color: Colors.white, width: 2), // White border when focused
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: Colors.red, width: 2), // Red border when error
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 2), // Red accent border when focused and error
          ),
          // filled: true,
          // fillColor: Color.fromARGB(255, 50, 50, 50)
          //     .withOpacity(0.8), // Slightly transparent dark background
          hintText: 'Email',
          hintStyle: TextStyle(
              color: Colors.white
                  .withOpacity(0.6)), // Slightly transparent hint text
        ),
        onChanged: controller.onChangeUsername,
        validator: controller.validatorUsername,
      ),
    );
  }
}

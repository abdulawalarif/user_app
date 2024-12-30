import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/ui/constants/assets_path.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/auth_provider.dart';
import 'package:user_app/ui/utils/email_validator.dart';
import 'package:user_app/ui/utils/my_alert_dialog.dart';
import 'package:user_app/ui/widgets/reusable_text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late FocusNode _passwordNode;
  late FocusNode _emailFocusNode;
  late TextEditingController email;
  final _formKey = GlobalKey<FormState>();

  UserModel _user = UserModel();
  late String _password;
  bool _wrongEmailorPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordNode = FocusNode();
    _emailFocusNode = FocusNode();
    email = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordNode.dispose();
    _emailFocusNode.dispose();
    email.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();
    setState(() => _wrongEmailorPassword = false);
    if (isValid) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

     await authProvider.signIn(email: _user.email, password: _password).then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }).catchError((e) {
        print(e.toString());
        if (e.toString().contains('wrong-password') ||
            e.toString().contains('user-not-found')) {
          setState(() => _wrongEmailorPassword = true);
        } else if (e.toString().toLowerCase().contains('network')) {
          MyAlertDialog.connectionError(context);
        } else {
          MyAlertDialog.error(context, e.message.toString());
        }
      }).whenComplete(() {
        setState(() => _isLoading = false);
      });
    }
  }

  void _googleSignIn() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.googleSignIn().then((_) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                //  App Logo
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text(
                      ' ShopApp',
                      style: TextStyle(fontSize: 22),
                    )
                  ],
                ),

                //Show Log In error message
                Container(
                  height: 65,
                  padding: const EdgeInsets.only(top: 14),
                  child: _wrongEmailorPassword
                      ? const Text(
                          'The email or password you entered did not match our records. Please double check and try again',
                          style: TextStyle(color: Colors.redAccent),
                        )
                      : null,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email TextFormField
                      ReusableTextField(
                        controller: email,
                        focusNode: _emailFocusNode,
                        valueKey: 'Email',
                        validator: (value) =>
                            value == null || !EmailValidator.validateEmail(value) ? 'Please enter a valid email address' : null,
                        maxLines: 1,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passwordNode),
                        onSaved: (value) => _user.email = value!,
                      ),

                      // Password TextFormField
                      PasswordTextField(
                        focusNode: _passwordNode,
                        label: 'Password',
                        validator: (value) => value != null && value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onSaved: (value) => _password = value!,
                        onEditingComplete: _submitForm,
                      ),

                      // Forgot Password Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RouteName.forgotPasswordScreen,
                              );
                            },
                            child: Text(
                              'Forgot password ?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),

                      // Log in button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _submitForm(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoading
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : const Text('Log In'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Text(
                        '  or   ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),

                // Buttom Log In with Google
                _loginWithButton(
                  onPressed: _googleSignIn,
                  appLogoUrl: ImagePath.googleLogo,
                  title: 'Log in with Google',
                ),
                const SizedBox(height: 16),
                _loginWithButton(
                  onPressed: () {},
                  appLogoUrl: ImagePath.facebookLogo,
                  title: 'Log in with Facebook',
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, RouteName.signUpScreen);
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWithButton({
    String title = '',
    String appLogoUrl = '',
    required Function() onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        elevation: 0.6,
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).cardColor,
        textStyle: Theme.of(context).textTheme.labelLarge,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                appLogoUrl,
                fit: BoxFit.contain,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

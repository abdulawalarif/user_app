import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/auth_provider.dart';
import 'package:user_app/ui/constants/app_consntants.dart';
import 'package:user_app/ui/utils/my_border.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isLoading = false;
  String _noticeText = '';
  String _email = '';
  final _formKey =   GlobalKey<FormState>();
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider
          .resetPassword(email: _email)
          .then((value) => setState(() {
                _noticeText =
                    'A link to change your password  has been sent to your email, please check.';
              }))
          .catchError((e) => setState(() => _noticeText = e.message))
          .whenComplete(() => setState(() => _isLoading = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: TextFormField(
                  key: ValueKey('Email'),
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? 'Please enter a valid email address'
                      : null,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(mEmailIcon),
                    labelText: 'Email',
                    contentPadding: EdgeInsets.all(12),
                    border: const OutlineInputBorder(),
                    enabledBorder: MyBorder.outlineInputBorder(context),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onChanged: (_) => setState(() => _noticeText = ''),
                  onEditingComplete: _submitForm,
                  onSaved: (value) => _email = value!,
                ),
              ),

              // Reset button
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
                                color: Colors.white,
                              )
                            : Text('Change Password'),
                      ]),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(_noticeText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

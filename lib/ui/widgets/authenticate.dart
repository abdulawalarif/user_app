import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/providers/auth_provider.dart';
import 'package:user_app/ui/widgets/log_in_suggestion.dart';

class Authenticate extends StatefulWidget {
  final Widget child;
  const Authenticate({Key? key, required this.child}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    final _isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    if (_isLoggedIn) return widget.child;
    return Scaffold(body: LogInSuggestion());
  }
}

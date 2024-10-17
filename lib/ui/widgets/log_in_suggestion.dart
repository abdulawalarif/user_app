import 'package:flutter/material.dart';
import 'package:user_app/ui/constants/route_name.dart';
import 'package:user_app/ui/widgets/my_button.dart';



class LogInSuggestion extends StatelessWidget {
  const LogInSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30.0),
          Text(
            'You are not logged in.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20.0),
          Text(
            'There are a lot of great offers and features waiting for you. Join now !',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: MyButton.outlined(
                    context: context,
                    text: 'Log in',
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteName.logInScreen),),
              ),
              const SizedBox(width: 8),
              Expanded(
                  flex: 1,
                  child: MyButton.text(
                    context: context,
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteName.signUpScreen),
                    text: 'Sign Up',
                  ),),
            ],
          ),
        ],
      ),
    );
  }
}

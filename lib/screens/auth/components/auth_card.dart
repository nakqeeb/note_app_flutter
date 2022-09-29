import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/auth_notifier.dart';
import '../../../services/authService.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<double>? _obacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation = Tween<Size>(
            begin: const Size(double.infinity, 260),
            end: const Size(double.infinity, 320))
        .animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _obacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller?.dispose();
  }

  void _showErrorDialog(String message, AppLocalizations applocale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(applocale.error_occurred),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(applocale.okay),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final appLocale = AppLocalizations.of(context);
    var connectivityResult = await Connectivity().checkConnectivity();
    // check if the user is not connected to mobile network and wifi.
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      _showErrorDialog(appLocale!.no_connection, appLocale);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      if (_authMode == AuthMode.Login) {
        // Log user in
        await AuthService.login(
          _authData['email'] as String,
          _authData['password'] as String,
          authNotifier,
        );
      } else {
        // Sign user up
        await AuthService.signup(
          _authData['email'] as String,
          _authData['password'] as String,
          authNotifier,
        );

        _formKey.currentState?.reset();
        /* setState(() {
          _passwordController.text = '';
          _authMode = AuthMode.Login;
        }); */
      }
    } catch (error) {
      print(error);
      var errorMessage = appLocale!.opps_went_wrong;
      if (error.toString().contains('User is already exist.')) {
        errorMessage = appLocale.user_exist;
      } else if (error
              .toString()
              .contains('Invalid authentication credentials.') ||
          error.toString().contains('Auth failed.')) {
        errorMessage = appLocale.email_or_password_incorrect;
      }

      _showErrorDialog(errorMessage, appLocale);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller?.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        // height: 260,
        // height: _heightAnimation?.value.height,
        // constraints: BoxConstraints(minHeight: 260),
        /* constraints:
                BoxConstraints(minHeight: _heightAnimation!.value.height), */
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /* AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _obacityAnimation!,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: const InputDecoration(labelText: 'Name'),
                      textCapitalization: TextCapitalization.sentences,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value!.isEmpty) {
                                return 'Name can not be empty!';
                              }
                            }
                          : null,
                      onSaved: (value) {
                        _authData['name'] = value!;
                      },
                    ),
                  ),
                ), */
                TextFormField(
                  decoration: InputDecoration(labelText: appLocale!.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return appLocale.invalid_email;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: appLocale.password),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return appLocale.password_short;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                // if (_authMode == AuthMode.Signup)

                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.Login
                        ? appLocale.login
                        : appLocale.signup),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      textStyle: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .labelLarge!
                              .color),
                    ),
                  ),
                TextButton(
                  child: Text(_authMode == AuthMode.Login
                      ? appLocale.signup_instead
                      : appLocale.login_instead),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

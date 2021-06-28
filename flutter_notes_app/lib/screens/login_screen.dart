import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/bloc/blocs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pop();
            } else if (state.isFailure) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.errorMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      )
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  Stack _buildBody(LoginState state) {
    return Stack(
      children: [
        _buildForm(state),
        state.isSubmitting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  ListView _buildForm(LoginState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 40.0,
        horizontal: 24.0,
      ),
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.grey[200]),
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          autovalidate: true,
          validator: (_) =>
              !state.isEmailValid && _emailController.text.isNotEmpty
                  ? 'Invalid email'
                  : null,
          onChanged: (val) =>
              context.read<LoginBloc>().add(EmailChanged(email: val)),
        ),
        const SizedBox(height: 40.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.grey[200]),
          style: const TextStyle(color: Colors.black),
          obscureText: true,
          autovalidate: true,
          validator: (_) =>
              !state.isPasswordValid && _passwordController.text.isNotEmpty
                  ? 'Password must be at least 6 characters'
                  : null,
          onChanged: (val) =>
              context.read<LoginBloc>().add(PasswordChanged(password: val)),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: state.isFormValid
                ? () => context.read<LoginBloc>().add(
                      LoginPressed(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    )
                : null,
            child: Text('Login'),
          ),
        ),
        const SizedBox(height: 40.0),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: state.isFormValid
                ? () => context.read<LoginBloc>().add(
                      SignupPressed(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    )
                : null,
            child: Text('Sign Up'),
          ),
        )
      ],
    );
  }
}
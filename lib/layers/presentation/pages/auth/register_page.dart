import 'package:agenda/layers/domain/auth/entity/register.dart';
import 'package:agenda/layers/application/auth/register/register_cubit.dart';
import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(

          color: Color.fromARGB(255, 2, 39, 70),

        ),
        child: const _View(),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Register with Firebase
  void _firebaseRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            Register(_emailController.text, _passwordController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterPageStatus.success) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state.status == RegisterPageStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                Icon(Icons.lock_open,size: 100,color: Colors.blue[900],),
                Gap(30.0),

                const SizedBox(height: 15.0),
                // Email Input Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration:  InputDecoration(
                    hintStyle: TextStyle(color: Colors.white70),
                     filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                // Password Input Field
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,

                  decoration:  InputDecoration(
                    hintStyle: TextStyle(color: Colors.white70),

                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50.0),
                const Text(
                  "Already have an account ?",
                  style: TextStyle(color: Colors.white70),
                ),
                const Gap(10.0),
                const GradientButton(),
                const Spacer(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _firebaseRegister(); // Funktsiyani chaqirishni to'g'irladim
                      },
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                      child: state.status == RegisterPageStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator.adaptive())
                          : const Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
                // const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        onPressed: () {
          Navigator.pop(context); // Log In tugmasi ishlatilgan
        },
        child: const Text(
          "Log In",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// import 'package:agenda/di/di.dart';
// import 'package:agenda/layers/application/auth/sign_up/sign_up_cubit.dart';
// import 'package:agenda/layers/domain/entity/user_entity.dart';
// import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
// import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// class RegisterPage extends StatelessWidget {
//   const RegisterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 2, 39, 70),
//         ),
//         child: const _View(),
//       ),
//     );
//   }
// }

// class _View extends StatefulWidget {
//   const _View();

//   @override
//   State<_View> createState() => __ViewState();
// }

// class __ViewState extends State<_View> {
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _firebaseRegister1(BuildContext context) {
//     final cubit = context.read<SignUpCubit>();
//     if (_formKey.currentState!.validate()) {
//       cubit.signUp(UserEntity(
//         email: _emailController.text,
//         password: _passwordController.text,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<SignUpCubit>(), // Cubit yaratilganligini tekshiring.
//       child: BlocConsumer<SignUpCubit, SignUpState>(
//         listener: (context, state) {
//           if (state.status == SignUpStatus.success) {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => const HomePage()),
//               (route) => false,
//             );
//           } else if (state.status == SignUpStatus.failed) {
//             showMessage(context: context, message: state.error.toString());
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   const Spacer(),
//                   Icon(
//                     Icons.lock_open,
//                     size: 100,
//                     color: Colors.blue[900],
//                   ),
//                   const Gap(30.0),

//                   // Email Input Field
//                   TextFormField(
//                     style: const TextStyle(color: Colors.white),
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       hintStyle: const TextStyle(color: Colors.white70),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 18,
//                         horizontal: 20,
//                       ),
//                       hintText: 'Email',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15.0),

//                   // Password Input Field
//                   TextFormField(
//                     controller: _passwordController,
//                     style: const TextStyle(color: Colors.white),
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintStyle: const TextStyle(color: Colors.white70),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 18,
//                         horizontal: 20,
//                       ),
//                       hintText: 'Password',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 50.0),

//                   const Text(
//                     "Already have an account ?",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   const Gap(10.0),
//                   const GradientButton(),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       FloatingActionButton(
//                         onPressed: () => _firebaseRegister1(context),
//                         backgroundColor: Colors.blue[900],
//                         foregroundColor: Colors.white,
//                         child: state.status == SignUpStatus.loading
//                             ? const CircularProgressIndicator.adaptive()
//                             : const Icon(Icons.arrow_forward_rounded),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class GradientButton extends StatelessWidget {
//   const GradientButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue[900],
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: const Text(
//           "Log In",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

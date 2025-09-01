import 'package:agenda/layers/domain/auth/entity/login.dart';
import 'package:agenda/layers/application/auth/login/login_cubit.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/auth/register_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_page.dart';
import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ----------------------------------------------------------------
// PAGE
// ----------------------------------------------------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 39, 70),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 2, 39, 70),
        ),
        child: const _view(),
      ),
    );
  }
}

// ----------------------------------------------------------------
// View
// ----------------------------------------------------------------
class _view extends StatefulWidget {
  const _view();

  @override
  State<_view> createState() => __viewState();
}

class __viewState extends State<_view> {
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

  _firebaseLogin() {
    if (_formKey.currentState!.validate()) {
      context
          .read<LoginCubit>()
          .login(Login(_emailController.text, _passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginPageStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (state.status == LoginPageStatus.error) {
          showMessage(context: context, message: state.error.toString());
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(),

                Gap(20.h),
                const Text(
                  "Agenda",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(30.0),

                // const Spacer(),
                // Email Input Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.white),
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
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    _firebaseLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: state.status == LoginPageStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : const Text("Login", style: TextStyle(fontSize: 17.0)),
                ),
                // Sign up option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No account ?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ],
                ),

                // const Gap(10.0),

                const Spacer(),
                const Spacer()
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:agenda/di/di.dart';
// import 'package:agenda/infrastructure/globals.dart';
// import 'package:agenda/layers/application/auth/cubit/sign_in_with_google_cubit.dart';
// import 'package:agenda/layers/application/auth/sign_in/sign_in_cubit.dart';
// import 'package:agenda/layers/domain/auth/entity/login.dart';
// import 'package:agenda/layers/application/auth/login/login_cubit.dart';
// import 'package:agenda/layers/domain/entity/user_entity.dart';
// import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
// import 'package:agenda/layers/presentation/pages/auth/register_page.dart';
// import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// // ----------------------------------------------------------------
// // PAGE
// // ----------------------------------------------------------------
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 2, 39, 70),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 2, 39, 70),
//         ),
//         child: const _view(),
//       ),
//     );
//   }
// }

// // ----------------------------------------------------------------
// // View
// // ----------------------------------------------------------------
// class _view extends StatefulWidget {
//   const _view();

//   @override
//   State<_view> createState() => __viewState();
// }

// class __viewState extends State<_view> {
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



//   _firebaseLogin1() {
//     final cubit = BlocProvider.of<SignInCubit>(context);
//     if (_formKey.currentState!.validate()) {
//       context.read<SignInCubit>().signIn(UserEntity(
//           email: _emailController.text, password: _passwordController.text));

//       cubit.signIn(UserEntity(
//           email: _emailController.text, password: _passwordController.text
//               .replaceAll('+', 'replace')
//               .replaceAll('+', '')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<SignInCubit>(),
//       child: BlocConsumer<LoginCubit, LoginState>(
//         listener: (context, state) {
//           if (state.status == LoginPageStatus.success) {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (context) => const HomePage()),
//               (route) => false,
//             );
//           } else if (state.status == LoginPageStatus.error) {
//             showMessage(context: context, message: state.error.toString());
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Spacer(),

//                   Gap(20.h),
//                   const Text(
//                     "Agenda",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 48.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Gap(30.0),

//                   // const Spacer(),
//                   // Email Input Field
//                   TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       hintText: 'Email',
//                       hintStyle: const TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 18, horizontal: 20),
//                     ),
//                     style: const TextStyle(color: Colors.white),
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
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.1),
//                       hintText: 'Password',
//                       hintStyle: const TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 18, horizontal: 20),
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15.0),
//                   // Login Button
//                   ElevatedButton(
//                     onPressed: () {
//                       _firebaseLogin1();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[900],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 100.0, vertical: 12.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: state.status == LoginPageStatus.loading
//                         ? const Center(
//                             child: CircularProgressIndicator.adaptive())
//                         : const Text("Login", style: TextStyle(fontSize: 17.0)),
//                   ),
//                   // Sign up option
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "No account ?",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       TextButton(
//                           onPressed: () {
//                             try {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const RegisterPage()),
//                               );
//                             } catch (e) {
//                               print("Error navigating to RegisterPage: $e");
//                             }
//                           },
//                           child: const Text(
//                             "Sign Up",
//                             style: TextStyle(color: Colors.blue),
//                           )),
//                     ],
//                   ),

//                   // const Gap(10.0),

//                   const Spacer(),
//                   const Spacer()
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class _SignInOptions extends StatelessWidget {
//   const _SignInOptions();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Google orqali kirish uchun tugma
//         _SignInOption(
//           icon: Icons.facebook, // Google belgisini qo'shish
//           onPressed: () {
//             context.read<SignInWithGoogleCubit>().signInWithGoogle();
//           },
//         ),
//       ],
//     );
//   }
// }

// class _SignInOption extends StatelessWidget {
//   final IconData icon; // `IconData` turiga o'zgartirildi
//   final VoidCallback onPressed;

//   const _SignInOption({
//     required this.icon,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: 68.0, // Ekran o'lchamlariga moslashtirish
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: const Color(0xffFFFFFF),
//           border: Border.all(color: const Color(0xffE8E8E8)),
//           borderRadius: BorderRadius.circular(6.0),
//         ),
//         child: Center(
//           child: Icon(
//             icon, // Bu yerda SVG o'rniga oddiy belgi ishlatilmoqda
//             size: 36.0,
//             color: Colors.black, // Belgining rangi
//           ),
//         ),
//       ),
//     );
//   }
// }

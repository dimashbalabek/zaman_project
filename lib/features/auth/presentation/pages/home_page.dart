// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_clean_architecture_practise/features/auth/presentation/pages/sign_up_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   Future<void> checkAndCreateUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userDoc =
//           FirebaseFirestore.instance.collection('users').doc(user.uid);
//       final docSnapshot = await userDoc.get();
//       if (!docSnapshot.exists) {
//         await userDoc.set({
//           'rating': 5,
//           'phone': user.phoneNumber ?? '',
//           'email': user.email ?? '',
//         });
//       }
//     }
//   }

//   Future<void> logOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => SignUpPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       checkAndCreateUserData();
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to Flutter!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => logOut(context),
//               child: const Text('Log out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

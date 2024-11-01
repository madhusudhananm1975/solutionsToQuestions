// Author: Madhu
//Purpose: Solution to 3 Questions
//Please refer to bottom of this page for Questions
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'imagehandler.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized( );
  if (kIsWeb){
      await Firebase.initializeApp(
          options: const FirebaseOptions(
                          apiKey: "AIzaSyB6i2QNaCpzqo_1XPzxJ8kBbK0aXt7qxn4",
                          authDomain: "imagestore-100.firebaseapp.com",
                          projectId: "imagestore-100",
                          storageBucket: "imagestore-100.appspot.com",
                          messagingSenderId: "134469257261",
                          appId: "1:134469257261:web:15ed5817740149666f90a4"
                        )
                     );
              }
    runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const ImageHandler(),
      },
    );
  }
}

/*
Question 1: ( compulsory if FE stack )
Create a file upload feature that accepts any image or video files, less than 10 MB and
upload the file to the firebase storage.
Add some some interactions or animations like upload progress and file upload status
Add a preview of the file that has been uploaded.
Place appropriate validations and error messages wherever required
Question 2:
Write a simple application using a recursive function that accepts a value (integer) and
returns the fibonacci value at that position in the series.
The application should be performant at scale to handle larger numbers without slowing
down exponentially.
Question 3:
A string is balanced if it consists of exactly two different characters and both of those
characters appear exactly the same number of times. For example: "aabbab" is
balanced (both 'a' and 'b' occur three times) but "aabba" is not balanced ('a' occurs three
times, 'b' occurs two times). String "aabbcc" is also not balanced (it contains three
different letters).A substring of string S is a string that consists of consecutive letters in
S. For example: "ompu" is a substring of "computer" but "cmptr" is not.Write a function
solution called getBalancedSubstrings(List<String> S) that, given a string S, returns an
array of the longest balanced substring of S.Examples:
1. Given S = "cabbacc", the function should return ["abba"] because it is the longest
balanced substring.
2. Given S = "abababa", the function should return ["ababab", "bababa"] which are the
longest balanced substrings.
3. Given S = "aaaaaaa", the function should return [] since S does not contain a
balanced substring.Write an efficient algorithm for the following assumptions:
- N is an integer within the range [1..100,000];
- string S is made only of lowercase letters (a−z)
*/

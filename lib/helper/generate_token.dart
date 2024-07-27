
import 'package:random_password_generator/random_password_generator.dart';



// double passwordstrength = password.checkPassword('hello');
//
// if (passwordstrength < 0.3)
// print('This password is weak!');
// else if (passwordstrength < 0.7)
// print('This password is Good');
// else
// print('This passsword is Strong');

String generateToken(double length){

  final password = RandomPasswordGenerator();

  return password.randomPassword(letters: true,numbers: true,passwordLength: length,specialChar: false,uppercase: true);

}
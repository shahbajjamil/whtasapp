import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify your number'),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("We have sent an SMS with a code."),
              SizedBox(
                width: size.width * .5,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "- - - - - -",
                      hintStyle: TextStyle(fontSize: 30)),
                  onChanged: (value) {},
                ),
              )
            ],
          ),
        ));
  }
}

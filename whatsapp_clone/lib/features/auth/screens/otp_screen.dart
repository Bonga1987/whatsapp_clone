import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/color.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({super.key, required this.verificationId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationId,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text('We have sent an SMS with a code'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

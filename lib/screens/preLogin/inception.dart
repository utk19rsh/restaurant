import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:utk19rsh/components/backend/backend.dart';
import 'package:utk19rsh/components/functions/functions.dart';
import 'package:utk19rsh/components/miscellaneous/snackbar.dart';
import 'package:utk19rsh/constant.dart';

class Inception extends StatefulWidget {
  static const String route = "/inception";

  const Inception({Key? key}) : super(key: key);

  @override
  State<Inception> createState() => _InceptionState();
}

class _InceptionState extends State<Inception> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  late String phone, otp, verificationId, uID;
  bool isKeyboardOpen = false;
  late ConfirmationResult confirmationResult;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isOtpSent = false, isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double customWidth = width / realmeWidth;
    double infinity = double.infinity;
    isKeyboardOpen = WidgetsBinding.instance.window.viewInsets.bottom > 0.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: trans,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: white,
          // statusBarIconBrightness:
          //     Platform.isAndroid ? Brightness.dark : Brightness.light,
          statusBarBrightness:
              Platform.isAndroid ? Brightness.dark : Brightness.light,
        ),
      ),
      body: SizedBox.expand(
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            mainAxisAlignment: isOtpSent
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: isKeyboardOpen
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 25,
                          color: theme,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      validator: (value) => validatePhone(value!),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (String value) {
                        if (value.length > 10) {
                          value = value.substring(value.length - 10);
                        }
                        phone = value;
                      },
                      onSaved: (value) {
                        if (validatePhone(phone) == null) {
                          sendPhoneOTP(context);
                          isOtpSent = true;
                          setState(() {});
                        } else {
                          buildSnackBar(
                            context,
                            "Invalid phone number",
                          );
                        }
                      },
                      autofillHints: [
                        Platform.isAndroid
                            ? AutofillHints.telephoneNumberNational
                            : AutofillHints.telephoneNumber,
                      ],
                      decoration: InputDecoration(
                        hintText: "Enter Phone",
                        prefixIcon: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 5),
                          width: 30,
                          height: 20,
                          child: const Text(
                            "+91",
                            style: TextStyle(
                              fontSize: 18.2,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isOtpSent)
                      TextFormField(
                        controller: otpController,
                        enabled: isOtpSent,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => otp = value,
                        decoration: const InputDecoration(
                          hintText: "Enter OTP",
                        ),
                      ),
                    isLoading
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 17.5,
                              vertical: 22.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 7.5,
                            ),
                            width: infinity,
                            child: const CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (isOtpSent) {
                                if (otp.length == 6) {
                                  verifyPhoneOTP(context);
                                } else {
                                  buildSnackBar(
                                    context,
                                    "Invalid OTP",
                                  );
                                }
                              } else {
                                if (validatePhone(phone) == null) {
                                  sendPhoneOTP(context);
                                  isOtpSent = true;
                                } else {
                                  buildSnackBar(
                                    context,
                                    "Invalid phone number",
                                  );
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 17.5,
                                vertical: 22.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              // height: 50,
                              width: infinity,
                              decoration: BoxDecoration(
                                color: theme,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isOtpSent ? "Continue" : "Send OTP",
                                    style: const TextStyle(
                                      color: white,
                                      fontSize: 17,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Icon(
                                    MdiIcons.login,
                                    color: white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendPhoneOTP(BuildContext context) async {
    String p = "+91$phone";

    buildSnackBar(context, "Sending OTP.");
    await firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: p,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential)
            .then((value) async {
          uID = firebaseAuth.currentUser!.phoneNumber!;
          try {
            await FirebaseFirestore.instance
                .collection("1AllUsers")
                .doc(uID)
                .set({"uID": uID});
          } catch (e) {
            debugPrint(e.toString());
          }
          await Backend().setPreferences(uID);
          if (mounted) {
            Navigator.pop(context);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        String error = "";
        if (e.message!.contains("Network")) {
          error = "Please check your internet connection.";
        } else {
          error = "Something went wrong, please try later.";
        }
        buildSnackBar(context, error);
      },
      codeSent: (verificationId, [int? forceResendingToken]) async {
        setState(() {
          this.verificationId = verificationId;
          isOtpSent = true;
        });
        buildSnackBar(context, "OTP sent successfully.");
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        buildSnackBar(context, "Timeout, please resend OTP.");
      },
    );
  }

  void verifyPhoneOTP(BuildContext context) async {
    String uID = "+91$phone";
    setState(() {
      isLoading = true;
    });

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpController.text,
    );
    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .catchError((onError) {
        setState(() {
          isLoading = false;
        });
        buildSnackBar(context, 'Something went wrong.');
      }).then((value) async {
        uID = firebaseAuth.currentUser!.phoneNumber!;
        try {
          await FirebaseFirestore.instance
              .collection("1AllUsers")
              .doc(uID)
              .set({"uID": uID});
        } catch (e) {
          debugPrint(e.toString());
        }

        await Backend().setPreferences(uID);
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      if (e.hashCode == 130296352) {
        buildSnackBar(context, "Account already exists.");
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

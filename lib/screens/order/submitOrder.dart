import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utk19rsh/components/backend/sharedPreferences.dart';
import 'package:utk19rsh/components/functions/functions.dart';
import 'package:utk19rsh/components/miscellaneous/snackbar.dart';
import 'package:utk19rsh/constant.dart';
import 'package:utk19rsh/screens/landing/cartProvider.dart';
import 'package:utk19rsh/screens/landing/components.dart';
import 'package:utk19rsh/screens/order/postSubmit.dart';
import 'package:utk19rsh/screens/preLogin/inception.dart';

class SubmitOrder extends StatefulWidget {
  const SubmitOrder({super.key});

  @override
  State<SubmitOrder> createState() => _SubmitOrderState();
}

class _SubmitOrderState extends State<SubmitOrder> {
  Color backgroundColor = Colors.grey[100]!;
  late double height, width;
  double infinity = double.infinity;
  late SharedPreferences pref;
  late int orderCount;
  String uID = "";

  @override
  void initState() {
    inception();
    super.initState();
  }

  inception() async {
    pref = await SharedPreferences.getInstance();
    uID = pref.getString("uID")!;
  }

  @override
  void dispose() {
    Provider.of<CartProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: trans,
        iconTheme: const IconThemeData(color: black),
        title: const Text("Tutor Bin Canteen"),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: infinity,
            height: infinity,
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                deliveryTime(),
                Consumer<CartProvider>(
                  builder: (context, value, child) {
                    Map<String, int> cart = value.cart;
                    Map<String, int> quantity = value.quantity;
                    int subtotal = value.cartAmount;
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        yourOrder(cart, quantity, context),
                        const SizedBox(height: 15),
                        total(subtotal),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            elevation: 20,
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (FirebaseAuth.instance.currentUser == null)
                  loginAlert(context),
                deliveryAt(),
                const Divider(),
                paymentButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container paymentButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        15,
        5,
        15,
        15 + MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: theme.withOpacity(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<CartProvider>(builder: (context, value, child) {
            int cartAmount = value.cartAmount;
            int total = (cartAmount + (cartAmount * 0.12)).toInt();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  indentCost(total),
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "TOTAL",
                  style: TextStyle(
                    color: white,
                    letterSpacing: 1,
                  ),
                )
              ],
            );
          }),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (FirebaseAuth.instance.currentUser != null &&
                  pref.getString("uID") != null) {
                List<String> items = Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).cart.keys.toList();
                List<int> prices = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).cart.values.toList(),
                    quantities = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).cart.values.toList();
                DateTime now = DateTime.now();
                await FirebaseFirestore.instance
                    .collection("AllOrders")
                    .doc(getDocId(time: now))
                    .set({
                  "items": items,
                  "prices": prices,
                  "quantities": quantities,
                  "createdAt": now,
                  "uID": uID,
                });
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const PostSubmit(),
                    ),
                  );
                }
              } else {
                buildSnackBar(context, "Please login");
              }
            },
            child: Row(
              children: const [
                Text(
                  "PAY NOW",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: white,
                  ),
                ),
                SizedBox(width: 2.5),
                Icon(
                  MdiIcons.menuRight,
                  color: white,
                  size: 28,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding deliveryAt() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(MdiIcons.mapMarker, color: theme),
              const SizedBox(width: 5),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Delivery at : ",
                      style: TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "Home",
                      style: TextStyle(
                        color: black,
                        fontSize: 17,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "Change",
              style: TextStyle(
                color: theme,
                fontSize: 17,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector loginAlert(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => const Inception(),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          width: infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Please login to place an order",
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1,
                  color: red,
                ),
              ),
              Icon(MdiIcons.chevronRight, color: red)
            ],
          ),
        ),
      ),
    );
  }

  Container total(int subtotal) {
    return Container(
      width: infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text(indentCost(subtotal)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                color: black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(MdiIcons.officeBuilding),
                      SizedBox(width: 5),
                      Text("GST"),
                      SizedBox(width: 5),
                      Icon(MdiIcons.informationOutline, size: 16),
                    ],
                  ),
                  Text(indentCost((subtotal * 0.12).toInt()))
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 5),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: theme,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    // Icon(MdiIcons.currencyInr, color: theme),
                    // SizedBox(width: 15),
                    Text("Grand Total"),
                  ],
                ),
                Text(indentCost((subtotal + (subtotal * 0.12)).toInt()))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container yourOrder(
    Map<String, int> cart,
    Map<String, int> quantity,
    BuildContext context,
  ) {
    return Container(
      width: infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                MdiIcons.clipboardListOutline,
                color: theme,
              ),
              SizedBox(width: 15),
              Text(
                "Your Order",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            itemCount: cart.length,
            itemBuilder: (context, index) {
              String name = cart.keys.elementAt(index);
              int price = cart.values.elementAt(index);
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MenuCategoryTileBody(
                        name: name,
                        price: price,
                        submittingOrder: true,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Add more items ?",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Icon(MdiIcons.chevronRight, color: theme),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container deliveryTime() {
    return Container(
      width: infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: const [
          Icon(
            MdiIcons.clockCheckOutline,
            color: theme,
          ),
          SizedBox(width: 15),
          Text(
            "Delivery in 25 mins",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

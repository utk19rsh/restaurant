// // import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyOrders {
//   final int orderCount;
//   final List<String> items;
//   final List<int> quantities, prices;

//   MyOrders({
//     required this.items,
//     required this.orderCount,
//     required this.prices,
//     required this.quantities,
//   });

//   late SharedPreferences sp;

//   addOrder() async {
//     List<String> finalQuantities = quantities
//         .asMap()
//         .map((key, value) => MapEntry(key, value.toString()))
//         .values
//         .toList();
//     List<String> finalPrices = prices
//         .asMap()
//         .map((key, value) => MapEntry(key, value.toString()))
//         .values
//         .toList();
//     sp = await SharedPreferences.getInstance();
//     sp.setInt("orderCount", orderCount);
//     sp.setStringList("order${orderCount}items", items);
//     sp.setStringList("order${orderCount}quantities", finalQuantities);
//     sp.setStringList("order${orderCount}prices", finalPrices);
//   }

//   Future<List<String>> getOrderItems(int orderCount) async {
//     sp = await SharedPreferences.getInstance();
//     return sp.getStringList("order${orderCount}items") ?? [];
//   }

//   Future<List<String>> getOrderPrices(int orderCount) async {
//     sp = await SharedPreferences.getInstance();
//     return sp.getStringList("order${orderCount}prices") ?? [];
//   }

//   Future<List<String>> getOrderQuantities(int orderCount) async {
//     sp = await SharedPreferences.getInstance();
//     return sp.getStringList("order${orderCount}quantities") ?? [];
//   }
// }

import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Map<String, int> cart = {};
  Map<String, int> quantity = {};
  List<String> bestSellers = [];
  // I could have also used Map<String, Set(int,int)> but that would've made the code difficult to read.
  int cartAmount = 0;

  inception() async {
    try {
      final QuerySnapshot qs =
          await FirebaseFirestore.instance.collection("AllOrders").get();
      List<String> items = [];
      for (DocumentSnapshot ds in qs.docs) {
        items = [...items, ...ds["items"]];
      }
      Map<String, int> frequency = {};
      for (String item in items) {
        frequency.update(item, (value) => ++value, ifAbsent: () => 1);
      }
      List<dynamic> sortedKeys = frequency.keys.toList(growable: false)
        ..sort((k1, k2) => frequency[k2]!.compareTo(frequency[k1]!));
      frequency = LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => frequency[k]!,
      );
      bestSellers.add(frequency.keys.elementAt(0));
      bestSellers.add(frequency.keys.elementAt(1));
      bestSellers.add(frequency.keys.elementAt(2));
      notifyListeners();
    } catch (e) {
      bestSellers = [];
    }
  }

  addItem(String key, int value) {
    cart.addAll({key: value});
    quantity.addAll({key: 1});
    cartAmount += value;
    notifyListeners();
  }

  removeItem(String key, int value) {
    cartAmount -= value;
    cart.removeWhere((k, v) => k == key);
    quantity.removeWhere((k, v) => k == key);
    notifyListeners();
  }

  increaseQuantity(String key, int value) {
    cart.update(key, (v) => value);
    quantity.update(key, (v) => ++v);
    cartAmount += value;
    notifyListeners();
  }

  decreaseQuantity(String key, int value) {
    cart.update(key, (v) => value);
    quantity.update(key, (v) => --v);
    cartAmount -= value;
    notifyListeners();
  }
}

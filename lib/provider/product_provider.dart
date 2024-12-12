import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:task/modal/OurResult.dart';
import 'package:task/modal/Product.dart';
import 'dart:convert';

import '../utilities/sharedpreferencehelper.dart'; // For json decoding

class ProductProvider with ChangeNotifier {

  SharedPreferenceHelper sharedPref = SharedPreferenceHelper();


  Future<OurResult> addProduct(Product product)async{
    await sharedPref.init();
    final result =  await sharedPref.addProduct(product);
    refreshProducts();
    return result;
  }

  List<Product> get allProducts => _allProducts;
  List<Product> _allProducts = [];

  void refreshProducts() async {
   await  sharedPref.init();
    _allProducts.clear();
    _allProducts = await sharedPref.getAllProducts();
    notifyListeners();
  }

  void deleteProduct(Product product) async {
    await sharedPref.init();
    await sharedPref.deleteProduct(product);
    refreshProducts();
  }

  void searchProducts(String query) async {
    _allProducts.clear();

    if(query.isEmpty){
      refreshProducts();
      return;
    }

    final searchedProducts =  await sharedPref.searchProducts(query);
    if(searchedProducts.isEmpty){
      notifyListeners();
      return;
    }

    _allProducts = searchedProducts;
    notifyListeners();
  }
}
import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/modal/OurResult.dart';

import '../modal/Product.dart';

class SharedPreferenceHelper {
  static final SharedPreferenceHelper _instance =
  SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _instance;
  }

  SharedPreferenceHelper._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Product Functions
  Future<OurResult> addProduct(Product product) async {
    try {
      final productList = await getAllProducts();
      if (!productList.any((p) => p.name == product.name)) {
        final productListString = _encodeProductList(productList + [product]);
        await _prefs.setString('products', productListString);
        return OurResult(message: 'Product saved!', success: true);
      } else {
        // Handle duplicate product error
        return OurResult(message: 'Product with the same name already exists.', success: false);
      }
    } catch (e) {
      // Handle error saving to SharedPreferences
      print(e);
      return OurResult(message: 'Error saving product: $e', success: false);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final productList = await getAllProducts();
      final index = productList.indexWhere((p) => p.name == product.name);
      if (index != -1) {
        productList[index] = product;
        final productListString = _encodeProductList(productList);
        await _prefs.setString('products', productListString);
      } else {
        // Handle product not found error
        print('Product not found.');
      }
    } catch (e) {
      // Handle error updating product
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      final productList = await getAllProducts();
      final productListString = _encodeProductList(
          productList.where((p) => p.name != product.name).toList());
      await _prefs.setString('products', productListString);
    } catch (e) {
      // Handle error deleting product
      print('Error deleting product: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final productListString = _prefs.getString('products');
    if (productListString != null) {
      return _decodeProductList(productListString);
    } else {
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final productList = await getAllProducts();
    return productList.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Token Functions
  Future<void> setToken(String? token) async {
    await _prefs.setString('token', token ?? "");
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  // Helper Functions
  String _encodeProductList(List<Product> products) {
    return jsonEncode(products.map((product) => product.toJson()).toList());
  }

  List<Product> _decodeProductList(String productListString) {
    log("Saved list > $productListString");
    final List<dynamic> jsonList = jsonDecode(productListString);
    return jsonList.map((productJson) => Product.fromJson(productJson)).toList();
  }

}
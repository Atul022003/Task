import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/add_product.dart';
import 'package:task/login_page.dart';
import 'package:task/modal/Product.dart';
import 'package:task/provider/auth_provider.dart';
import 'package:task/provider/product_provider.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
  return HomePageState();
  }

}
class HomePageState extends State<HomePage>{

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context ,listen: false);
    provider.refreshProducts();
  }
  @override
  Widget build(BuildContext context) {


    final provider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
  return Scaffold(floatingActionButton:FloatingActionButton(
    onPressed: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => AddProduct()));
    },
    child: const Icon(Icons.add),
    tooltip: 'Add Item',
  ) ,
    appBar: AppBar(
      actions: [
        IconButton(onPressed: (){

          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logout?'),
                content:  SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Are you sure you want to logout?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      authProvider.logout();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));

                    },
                  ),
                ],
              );
            },
          );


        }, icon: Icon(Icons.logout))

      ],
      automaticallyImplyLeading: false,
      title: Text("HomePage"),
    ),
    body: Column(
      children: [
        Padding(padding: EdgeInsets.all(20),
        child:  TextField(
          onChanged: (query){
            provider.searchProducts(query);
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              hintText: "Search",
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),

              )
          ),
        ),),

        SizedBox(
          height: 10,
        ),

        (provider.allProducts.isNotEmpty) ? GridView.count(
          mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    primary: false,
    padding:const EdgeInsets.all(10),
    crossAxisCount:  2,
    shrinkWrap: true,
    children: provider.allProducts.map((product) => ProductWidget(product,provider)).toList()) : Column(children: [

          Icon(Icons.list),
          Text("No Products Found")

        ],)



      ],
    )


  );
  }

  Widget ProductWidget(Product product,ProductProvider provider){
    return Stack(children: [

      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: Column(children: [
          SizedBox(height: 20,),
          (product.imagePath.isNotEmpty) ? Image.file(File(product.imagePath),height: 100,) : SizedBox(),
          SizedBox(height: 10,),
          Text(product.name,style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
          Text("₹ ${product.price}"),

        ],),),

      Align(alignment: Alignment.topRight,
      child: InkWell(onTap: (){

        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Product?'),
              content:  SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure you want to delete "${product.name}" from product list?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    provider.deleteProduct(product);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );


      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red.shade100,
        ),
        padding: EdgeInsets.all(10),
        child:Icon(Icons.delete_outline_rounded,color: Colors.red,) ,),),)


    ],);
  }

}
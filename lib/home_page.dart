import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/add_product.dart';
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
  return Scaffold(floatingActionButton:FloatingActionButton(
    onPressed: () {
      Navigator.push(context,MaterialPageRoute(builder: (context) => AddProduct()));
    },
    child: const Icon(Icons.add),
    tooltip: 'Add Item',
  ) ,
    appBar: AppBar(
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.logout))

      ],
      automaticallyImplyLeading: false,
      title: Text("HomePage"),
    ),
    body: Column(
      children: [
        Padding(padding: EdgeInsets.all(20),
        child:  TextField(
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

        Column(children: provider.allProducts.map((product) =>
        ListTile(
          leading: (product.imagePath.isNotEmpty) ? Image.file(File(product.imagePath),
            fit: BoxFit.cover,width: 50,height: 50,) : SizedBox(),
          title: Text(product.name ?? "~"),
          subtitle: Text("${product.price}"),trailing: InkWell(child: Icon(Icons.delete),
        onTap: (){
            provider.deleteProduct(product);
        },),)).toList(),)



      ],
    )


  );
  }

}
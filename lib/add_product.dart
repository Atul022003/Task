import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:task/modal/Product.dart';
import 'package:task/provider/product_provider.dart';

class AddProduct extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddProductState();
  }

}
class AddProductState extends State<AddProduct>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _image;

  Future _pickImage() async {

      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final File file = File(image.path);
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      log("image path  > $imagePath");
      await file.copy(imagePath);

      setState(() {
        _image = File(imagePath);
      });

  }

  void saveProduct() async {
    if(_nameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("enter a valid product name")));
      return;
    }

    if(_priceController.text.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("enter a valid product price")));
      return;
    }

    final provider = Provider.of<ProductProvider>(context ,listen: false);
    final result = await provider.addProduct(Product(name: _nameController.text,
        price: double.parse(_priceController.text), imagePath: _image?.path ?? ""));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)));

    if(result.success){
      Navigator.pop(context);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Add product"),
      ),
      body: Padding(padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
            ),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
            )
            ),
            SizedBox(height: 10,),
            if(_image!=null) Image.file(_image!,height: 100,),
            ElevatedButton(onPressed: (){
              _pickImage();
            }, child:Text("Choose Image")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed:(){
              saveProduct();
            }, child: Text("Save Product"))
          ],
        ),

      ),
    );
  }

}
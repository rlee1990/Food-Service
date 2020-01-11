import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_dev/Models/food_item.dart';
import 'package:food_dev/Models/food_items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class EditItemsView extends StatefulWidget {
  EditItemsView({Key key}) : super(key: key);

  @override
  _EditItemsViewState createState() => _EditItemsViewState();
}

class _EditItemsViewState extends State<EditItemsView> {
  final _titleNode = FocusNode();
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _form = GlobalKey<FormState>();
  List<String> foodCategory = ['Salads', 'Sandwiches',
  'Chicken',
  'Drinks',
  'Sides'];
  bool _hasPhoto = false;
  File _image;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isInit = true;
  var _foodItem = FoodItem(
      id: null,
      title: '',
      price: 0.0,
      description: '',
      imageUrl:
          'https://www.seriouseats.com/recipes/images/20090520-barbecue-chicken.jpg',
      category: '');
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'category': '',
    'price': ''
  };
  var _isloading = false;

  Future _getImageGallery() async {
    PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.photos,
      PermissionGroup.storage
    ]).then((result) {
      if (result.containsValue(PermissionStatus.granted)) {
        ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
          if (image != null) {
            FlutterImageCompress.compressAndGetFile(
                    image.absolute.path, image.absolute.path,
                    quality: 80, format: CompressFormat.jpeg)
                .then((newImage) {
              if (newImage != null && mounted) {
                setState(() {
                  _hasPhoto = true;
                 _image = newImage; 
                });
              }
            });
          }
        });
      }
    });
  }

  Future _getImageCamera() async {
    PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.photos,
      PermissionGroup.storage
    ]).then((result) {
      if (result.containsValue(PermissionStatus.granted)) {
        ImagePicker.pickImage(source: ImageSource.camera).then((image) {
          if (image != null) {
            FlutterImageCompress.compressAndGetFile(
                    image.absolute.path, image.absolute.path,
                    quality: 80, format: CompressFormat.jpeg)
                .then((newImage) {
              if (newImage != null && mounted) {
                setState(() {
                  _hasPhoto = true;
                 _image = newImage; 
                });
              }
            });
          }
        });
      }
    });
  }

  _showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return SafeArea(
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(FontAwesomeIcons.cameraRetro),
                onPressed: () {
                  _getImageCamera();
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.images),
                onPressed: () {
                  _getImageGallery();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      
      setState(() {
        _isloading = true;
      });
      if (_foodItem.id != null) {
        Provider.of<FoodItems>(context, listen: false)
            .updateItem(_foodItem.id, _foodItem, _image)
            .catchError((error) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('An Error Occurred'),
                    content: Text(error.toString()),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }).then((_) {
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).pop();
        });
      } else {
        Provider.of<FoodItems>(context, listen: false)
            .addFoodItem(_foodItem, _image)
            .catchError((error) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('An Error Occurred'),
                    content: Text(error.toString()),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      )
                    ],
                  ));
        }).then((_) {
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final itemId = ModalRoute.of(context).settings.arguments as String;
      if (itemId != null) {
        _foodItem =
            Provider.of<FoodItems>(context, listen: false).findById(itemId);
        _initValues = {
          'title': _foodItem.title,
          'description': _foodItem.description,
          'price': _foodItem.price.toString(),
          'imageUrl': _foodItem.imageUrl,
          'category': _foodItem.category,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Manage Item'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: SafeArea(
        child: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: 'Title',
                              hintText: 'Jerk Chicken'),
                          textInputAction: TextInputAction.next,
                          focusNode: _titleNode,
                          validator: (value) {
                            return value.isEmpty ? 'Please add a title' : null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_priceNode);
                          },
                          onSaved: (value) {
                            _foodItem = FoodItem(
                                title: value,
                                id: _foodItem.id,
                                price: _foodItem.price,
                                description: _foodItem.description,
                                imageUrl: _foodItem.imageUrl,
                                isFavorite: _foodItem.isFavorite,
                                category: _foodItem.category);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: 'Price',
                              hintText: '25.99'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please add a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _foodItem = FoodItem(
                                title: _foodItem.title,
                                id: _foodItem.id,
                                isFavorite: _foodItem.isFavorite,
                                price: double.parse(value),
                                description: _foodItem.description,
                                imageUrl: _foodItem.imageUrl,
                                category: _foodItem.category);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: 'Description',
                              hintText: 'Jerk Chicken'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 10) {
                              return 'Please enter a longer description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _foodItem = FoodItem(
                                title: _foodItem.title,
                                id: _foodItem.id,
                                isFavorite: _foodItem.isFavorite,
                                price: _foodItem.price,
                                description: value,
                                imageUrl: _foodItem.imageUrl,
                                category: _foodItem.category);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Category', style: Theme.of(context).textTheme.title,),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButton(
                          items: foodCategory.map((String val) {
                            return DropdownMenuItem<String>(
                              child: Text(val),
                              value: val,
                            );
                          }).toList(),
                          value: _initValues['category'].isEmpty ? 'Chicken' : _initValues['category'],
                          onChanged: (value) {
                            setState(() {
                              _initValues['category'] = value;
                              _foodItem = FoodItem(
                                title: _foodItem.title,
                                id: _foodItem.id,
                                isFavorite: _foodItem.isFavorite,
                                price: _foodItem.price,
                                description: _foodItem.description,
                                imageUrl: _foodItem.imageUrl,
                                category: value);
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 150.0,
                          width: 150.0,
                          child: (_initValues['imageUrl'].isEmpty && !_hasPhoto)
                              ? IconButton(
                                  icon: Icon(FontAwesomeIcons.cameraRetro),
                                  onPressed: () {
                                    _showBottomSheet();
                                  },
                                )
                              : _initValues['imageUrl'].isNotEmpty && !_hasPhoto
                                  ? InkWell(
                                    onTap: () {
                                    _showBottomSheet();
                                  },
                                    child: Image.network(
                                      _initValues['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : InkWell(
                                    onTap: () {
                                    _showBottomSheet();
                                  },
                                    child: Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

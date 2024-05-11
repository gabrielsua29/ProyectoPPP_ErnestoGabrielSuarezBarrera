import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecommerce_app/assets/i18n/utils/localeConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int isSelected = 0;
  late List<dynamic> allProducts = [];
  late List<dynamic> filteredProducts = [];
  List<String> categories = [
    'All Products',
    'Electronics',
    'Clothing',
    'Jewelery'
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          FutureBuilder(
            future: getTranslatedString(context, 'ourProducts'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildProductCategory(
                    index: index, name: categories[index]);
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final product = filteredProducts[index];
                return _buildProductItem(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        _navigateToProductDetails(context, product);
      },
      child: Container(
        height: 250.0, // Set a fixed height for the Container
        child: Card(
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 100.0,
                  child: Image.network(
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  product['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$${product['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCategory({
    required int index,
    required String name,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            isSelected = index;
            _filterProducts(index);
          });
        },
        child: Container(
          width: 120,
          height: 40,
          margin: const EdgeInsets.only(top: 10, right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected == index ? Colors.red : Colors.red.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<void> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        allProducts = json.decode(response.body);
        filteredProducts = List.from(allProducts);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _filterProducts(int categoryIndex) {
    if (categoryIndex == 0) {
      setState(() {
        filteredProducts = List.from(allProducts);
      });
    } else {
      String selectedCategory = '';
      if (categoryIndex == 1) {
        selectedCategory = 'electronics';
      } else if (categoryIndex == 2) {
        selectedCategory = 'clothing';
      } else if (categoryIndex == 3) {
        selectedCategory = 'jewelery';
      }

      setState(() {
        if (selectedCategory.isNotEmpty) {
          if (categoryIndex == 1 || categoryIndex == 3) {
            filteredProducts = allProducts
                .where((product) => product['category'] == selectedCategory)
                .toList();
          } else if (categoryIndex == 2) {
            filteredProducts = allProducts
                .where((product) => product['category']
                    .toString()
                    .toLowerCase()
                    .contains(selectedCategory))
                .toList();
          }
        } else {
          filteredProducts = List.from(allProducts);
        }
      });
    }
  }

  void _navigateToProductDetails(
      BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }
}

Future<Map<String, dynamic>?> readUserData() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  String filePath = '$appDocPath/user.json';

  try {
    // Read the contents of the file
    String jsonContent = await File(filePath).readAsString();

    // Parse the JSON content
    return jsonDecode(jsonContent);
  } catch (e) {
    print('Error reading user data: $e');
    return null;
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getTranslatedString(context, 'productDetails'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              product['title'],
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        int quantity = 1;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(Icons.shopping_cart_outlined),
                                  SizedBox(width: 8),
                                  FutureBuilder(
                                    future: getTranslatedString(
                                        context, 'confirmPurchase'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${product['title']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Image.network(
                                    product['image'],
                                    height: 100,
                                  ),
                                  SizedBox(height: 8),
                                  FutureBuilder(
                                    future: getTranslatedString(
                                        context, 'itemPrice'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString() +
                                              "\$${product['price']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        },
                                        icon: Icon(Icons.remove),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  FutureBuilder(
                                    future: getTranslatedString(
                                        context, 'totalPrice'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString() +
                                              "\$${(product['price'] * quantity).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    // Read the user data from local storage
                                    final userData = await readUserData();
                                    print(userData);

                                    if (userData != null &&
                                        userData.containsKey('email')) {
                                      // Retrieve the Firestore collection for Usuarios
                                      final usuariosCollection =
                                          FirebaseFirestore.instance
                                              .collection('Usuarios');

                                      // Retrieve the document where email matches
                                      final userDoc = await usuariosCollection
                                          .doc(userData['email'])
                                          .get();

                                      if (userData['cardNumber'] != "") {
                                        String purchaseSuccessMsg =
                                            await getTranslatedString(
                                                context, 'purchaseSuccessMsg');
                                        Fluttertoast.showToast(
                                          msg: purchaseSuccessMsg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                        );
                                      }
                                    }

                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.blue.withOpacity(0.1),
                                    ),
                                  ),
                                  child: FutureBuilder(
                                    future:
                                        getTranslatedString(context, 'confirm'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.red.withOpacity(0.1),
                                    ),
                                  ),
                                  child: FutureBuilder(
                                    future:
                                        getTranslatedString(context, 'cancel'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: FutureBuilder(
                    future: getTranslatedString(context, 'buyButton'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            FutureBuilder(
              future: getTranslatedString(context, 'description'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product['description'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder(
              future: getTranslatedString(context, 'category'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 4),
            _buildProductCategory(
                name: product['category'].toString().toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCategory({
    required String name,
  }) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(top: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 128, 186, 207),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

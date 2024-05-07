import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Map<String, dynamic>> cartItems = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

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
          const Text(
            "Our Products",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
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
        builder: (context) => ProductDetailsPage(
          product: product,
          addToCartCallback: addToCart, // Passing the addToCart method
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>)
      addToCartCallback; // Callback function to add item to cart

  const ProductDetailsPage({
    Key? key,
    required this.product,
    required this.addToCartCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
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
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${product['price'].toStringAsFixed(2).split('.')[0]}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '.${product['price'].toStringAsFixed(2).split('.')[1]}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 4),
                ElevatedButton.icon(
                  onPressed: () {
                    // Call the callback function to add the product to the cart
                    addToCartCallback(product);
                    // Close the ProductDetailsPage
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text('Add to Cart'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
            Text(
              'Category:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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

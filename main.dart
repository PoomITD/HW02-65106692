import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // สำหรับการแปลงข้อมูล JSON
import 'models/product.dart'; // นำเข้าไฟล์ Product.dart
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // เพิ่มการนำเข้า flutter_rating_bar

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Product> products = []; // กำหนดค่าเริ่มต้นเป็นลิสต์ว่างๆ

  @override
  void initState() {
    super.initState();
    getData(); // เรียกใช้งาน getData เมื่อหน้าโหลด
  }

  // ฟังก์ชันดึงข้อมูลจาก API
  Future<void> getData() async {
    var url = Uri.parse('https://fakestoreapi.com/products');
    var response = await http.get(url); // ส่งคำขอ GET ไปยัง API
    setState(() {
      products = List<Product>.from(json.decode(response.body).map((data) => Product.fromJson(data)));
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.topLeft,
          child: const Text(
            'IT@WU Shop',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          var imgUrl = product.image ?? "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";
          return ListTile(
            title: Text("${product.title}"),
            subtitle: Text("\$${product.price}"),
            leading: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(imgUrl),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Details(),
                  settings: RouteSettings(
                    arguments: product,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Details();
  }
}

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    var imgUrl = product.image ?? "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(imgUrl),
          ),
          ListTile(
            title: Text(
              "${product.title}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "\$ ${product.price}",
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Category",
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              "${product.category}",
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: const Text(
              "Description",
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              "${product.description}",
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: RatingBar.builder(
              initialRating: product.rating?.rate ?? 0.0, // ค่าการให้คะแนนเริ่มต้น
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          ListTile(
            title: Text(
              "Rating: ${product.rating != null ? product.rating!.rate : 'N/A'}/5 of ${product.rating != null ? product.rating!.count : 'N/A'}",
            ),
          ),
        ],
      ),
    );
  }
}

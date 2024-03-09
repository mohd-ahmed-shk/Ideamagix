import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ideamagix/main.dart';
import 'package:ideamagix/model/product_response.dart';
import 'package:ideamagix/widgets/app_button.dart';
import 'package:ideamagix/widgets/app_text_field.dart';
import 'package:ideamagix/widgets/base_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool sort = true;

  Future<List<ProductResponse>> fetchData1() async {
    Uri url = sort
        ? Uri.parse('https://fakestoreapi.com/products')
        : Uri.parse('https://fakestoreapi.com/products?sort=desc');

    try {
      var response = await http.get(url);

      print("+++++++++++++${response.body}+++++++++++");

      if (response.statusCode == 200) {
        var jsonResponse = productResponseFromJson(response.body);

        print(
            "-------------------------------------$jsonResponse------------------");
        return jsonResponse;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data $e');
    }
  }

  List<ProductResponse> productList =
      []; // Create an empty list to store the data

  void fetchData() async {
    Uri url = sort
        ? Uri.parse('https://fakestoreapi.com/products')
        : Uri.parse('https://fakestoreapi.com/products?sort=desc');

    try {
      var response = await http.get(url);

      // Print the raw response for debugging
      print("+++++++++++++${response.body}+++++++++++");

      if (response.statusCode == 200) {
        List<ProductResponse> jsonResponse = productResponseFromJson(response.body);

        // Print the parsed response for debugging
        print(
            "-------------------------------------$jsonResponse------------------");

        // Populate the list with the fetched data
        setState(() {
          productList.addAll(jsonResponse);
        });

        // Use the productList within the function as needed
        print('Fetched products: $productList');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        // Handle the error as needed
      }
    } catch (e) {
      print('Failed to load data: $e');
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text("E-commerce"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20).r,
            child: Badge(
              label: Text(cartList.length.toString()),
              child: const Icon(CupertinoIcons.cart),
            ),
          )
        ],
      ),
      body: productList.isEmpty
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10).r,
            child: Column(
              children: [
                Row(
                  children: [
                    PopupMenuButton(
                      onSelected: (value) {
                        // your logic
                      },
                      itemBuilder: (BuildContext bc) {
                        return const [
                          PopupMenuItem(
                            value: '/sort',
                            child: Text("Sort"),
                          ),
                          PopupMenuItem(
                            child: Text("About"),
                            value: '/about',
                          ),
                          PopupMenuItem(
                            child: Text("Contact"),
                            value: '/contact',
                          )
                        ];
                      },
                    ),
                    Expanded(
                        child: AppTextField(
                          contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.search)),
                        )),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: productList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // number of items in each row
                          mainAxisSpacing: 8.0, // spacing between rows
                          crossAxisSpacing: 8.0, // spacing between columns
                          mainAxisExtent: 200.h),
                      itemBuilder: (context, index) {
                        ProductResponse? productData = productList[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if(cartList.contains(productList[index])) {
                                cartList.remove(productList[index]);
                              } else {
                                cartList.add(productList[index]);
                              }
                            });

                            print("==================${cartList.length}==============");
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    productData.image ?? "",
                                    width: 100.r,
                                    height: 100.r,
                                  ),
                                  10.verticalSpace,
                                  Expanded(
                                      child: Text(
                                          "Title : ${productData.title.substring(0, 15)}" ??
                                              "")),
                                  Expanded(
                                      child:
                                          Text("Price : ₹${productData.price}" ?? "")),
                                  AppButton(
                                      height: 30.h,
                                      onPressed: () {},
                                      title: cartList.contains(productList[index]) ? "Add" : "Remove" )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
          ),
    );
  }

  SafeArea buildSafeArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).r,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopupMenuButton(
                  onSelected: (value) {
                    // your logic
                  },
                  itemBuilder: (BuildContext bc) {
                    return const [
                      PopupMenuItem(
                        child: Text("Hello"),
                        value: '/hello',
                      ),
                      PopupMenuItem(
                        child: Text("About"),
                        value: '/about',
                      ),
                      PopupMenuItem(
                        child: Text("Contact"),
                        value: '/contact',
                      )
                    ];
                  },
                ),
                Expanded(
                    child: AppTextField(
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.search)),
                )),
              ],
            ),
            FutureBuilder<List<ProductResponse>>(
              future: fetchData1(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "=================${snapshot.error.toString()}============"),
                    );
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // number of items in each row
                            mainAxisSpacing: 8.0, // spacing between rows
                            crossAxisSpacing: 8.0, // spacing between columns
                            mainAxisExtent: 200.h),
                        itemBuilder: (context, index) {
                          ProductResponse? productData = snapshot.data?[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    productData?.image ?? "",
                                    width: 100.r,
                                    height: 100.r,
                                  ),
                                  10.verticalSpace,
                                  Expanded(
                                      child: Text(
                                          "Title : ${productData?.title.substring(0, 15)}" ??
                                              "")),
                                  Expanded(
                                      child: Text(
                                          "Price : ₹${productData?.price}" ??
                                              "")),
                                  AppButton(
                                      height: 30.h,
                                      onPressed: () {},
                                      title: "Add to Cart")
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

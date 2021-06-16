import 'package:catalogue/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class ProductTiles extends StatefulWidget {
  const ProductTiles({Key? key}) : super(key: key);

  @override
  _ProductTilesState createState() => _ProductTilesState();
}

class _ProductTilesState extends State<ProductTiles> {
  @override
  Widget build(BuildContext context) {
    final _productList = Provider.of<List<Product>>(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: _productList.map((product) {
        return Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.05),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Image.network(
                            product.imageUrl,
                            height: 400,
                            // cacheHeight: 400,
                            // cacheWidth: 296,
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_drop_down_circle),
                            title: Text('ID: ${product.productId} - ${product.name}'),
                            subtitle: Text(
                              product.price,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

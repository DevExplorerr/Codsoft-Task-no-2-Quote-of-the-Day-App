import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quote_app/widgets/quote_widget.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var apiURL = 'https://type.fit/api/quotes';

  Future<List<dynamic>> getPost() async {
    try {
      final response = await http.get(Uri.parse(apiURL));
      return postFromJson(response.body);
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  List<dynamic> postFromJson(String str) {
    List<dynamic> jsonData = json.decode(str);
    jsonData.shuffle();
    return jsonData;
  }

  final RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: getPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            return PageView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var model = snapshot.data![index];
                return QuoteWidget(
                  quote: model["text"]?.toString() ?? '',
                  author: model["author"]?.toString().isNotEmpty ?? false
                      ? model["author"]!.toString()
                      : 'Unknown',
                  bgColor: _randomColor.randomColor(
                    colorHue: ColorHue.multiple(
                      colorHues: [ColorHue.red, ColorHue.blue],
                    ),
                  ),
                  onLikeClick: () {},
                  onShareClick: () {},
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

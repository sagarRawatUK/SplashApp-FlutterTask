import 'dart:convert';
import 'dart:io';

import 'package:SplashApp/constants/widgets.dart';
import 'package:SplashApp/main.dart';
import 'package:SplashApp/views/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> wallpapersList = [];
  ScrollController scrollController = ScrollController();
  int pages = 1;
  bool isLoading = true;
  bool pageEnd = false;

  @override
  void initState() {
    super.initState();
    getWallpapers();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          pageEnd = true;
          pages += 1;
          getWallpapers();
        });
      } else {
        setState(() {
          pageEnd = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  getWallpapers() async {
    var apiUrl = "https://api.unsplash.com/photos/?page=" +
        pages.toString() +
        "&per_page=20&order_by=popular&client_id=inq1wLdc7-rEsHPyEq98Y8OQjkJdWHvKZJqj6dcaIxM";
    http.Response response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      try {
        final responseJson = jsonDecode(response.body);
        setState(() {
          wallpapersList += responseJson;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    } else
      print(response.reasonPhrase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SplashApp",
            style: GoogleFonts.sniglet(
                textStyle: TextStyle(color: Colors.white, fontSize: 23))),
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: !isLoading
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    color: mainColor,
                    child: StaggeredGridView.countBuilder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(10.0),
                      crossAxisCount: 4,
                      itemBuilder: (BuildContext context, int index) {
                        String imgPath =
                            wallpapersList[index]["urls"]["regular"];
                        return Card(
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImagePage(
                                          wallpapersList[index]["urls"]
                                              ["regular"],
                                          wallpapersList[index]["id"],
                                        ))),
                            child: Hero(
                                tag: imgPath,
                                child: FadeInImage(
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: AssetImage("assets/loading.png"),
                                  image: NetworkImage(imgPath),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) =>
                          StaggeredTile.count(2, index.isEven ? 2 : 3),
                      itemCount: wallpapersList.length,
                    ),
                  ),
                ),
                pageEnd
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        color: mainColor,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))
                    : Container()
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

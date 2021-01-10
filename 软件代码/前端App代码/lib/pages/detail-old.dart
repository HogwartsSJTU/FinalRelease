import 'package:Hogwarts/component/custom_drawer/navigation_home_screen.dart';
import 'package:Hogwarts/theme/hotel_app_theme.dart';
import 'package:Hogwarts/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/detail/tag.dart';
import 'package:Hogwarts/component/detail/comment.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'home.dart';


class Detail extends StatelessWidget {
  final spot;
  const Detail({Key key, this.spot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot['name']),
      ),
      body:
        ListView(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
            child: Image.asset(
              spot['image'],
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spot['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        print(spots[6]["lat"]);
                        print(spots[6]["lng"]);

                        Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(builder: (context)=> NavigationHomeScreen(isNavigate: true, fromToLocation: FromToLocation(
                                TextEditingController(text: spots[6]["lat"].toString()),
                                TextEditingController(text: spots[6]["lng"].toString()),
                                TextEditingController(text: spot["lat"].toString()),
                                TextEditingController(text: spot["lng"].toString())
                            ))),
                                (route)=>route==null
                        );
                      },
                      icon: Icon(Icons.explore),
                      color: Colors.blue,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: double.parse(spot["rate"]),
                  size: 20,
                  color: HotelAppTheme
                      .buildLightTheme()
                      .primaryColor,
                  borderColor: HotelAppTheme
                      .buildLightTheme()
                      .primaryColor,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    ShopTag(
                      icon: Icons.supervised_user_circle,
                      content: spot['count'],
                      color: Colors.pink[200],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ShopTag(
                      icon: Icons.bubble_chart,
                      content: spot['heat'],
                      color: Colors.cyan[200],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  spot['profile'],
                  style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 1,
                      wordSpacing: 3,
                      height: 1.2),
                ),
                SizedBox(
                  height: 10,
                ),
//                Comment(),
                SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

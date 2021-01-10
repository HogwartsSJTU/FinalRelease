class HotelListData {
  HotelListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.rating = 4.5,
    this.dist = 1.8,
    this.reviews = 80,
    this.perNight = 180,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  double rating;
  double dist;
  int reviews;
  int perNight;

  static List<HotelListData> hotelList = <HotelListData>[
    HotelListData(
      imagePath: 'assets/hotel/hotel_1.jpeg',
      titleTxt: '李政道图书馆',
      subTxt: '上海交通大学, 闵行区',
      dist: 2.0,
      reviews: 80,
      rating: 5.0,
      perNight: 180,
    ),
    HotelListData(
      imagePath: 'assets/hotel/hotel_2.jpeg',
      titleTxt: '包玉刚图书馆',
      subTxt: '上海交通大学, 闵行区',
      dist: 4.0,
      reviews: 74,
      rating: 4.0,
      perNight: 200,
    ),
    HotelListData(
      imagePath: 'assets/hotel/hotel_3.jpeg',
      titleTxt: '第四餐饮大楼',
      subTxt: '上海交通大学, 闵行区',
      dist: 3.0,
      reviews: 62,
      rating: 4.0,
      perNight: 60,
    ),
    HotelListData(
      imagePath: 'assets/hotel/hotel_4.jpeg',
      titleTxt: '菁菁堂',
      subTxt: '上海交通大学, 闵行区',
      dist: 7.0,
      reviews: 90,
      rating: 4.4,
      perNight: 170,
    ),
    HotelListData(
      imagePath: 'assets/hotel/hotel_5.jpeg',
      titleTxt: '甜魔咖啡',
      subTxt: '交大, 闵行区',
      dist: 2.0,
      reviews: 240,
      rating: 4.5,
      perNight: 200,
    ),
  ];
}

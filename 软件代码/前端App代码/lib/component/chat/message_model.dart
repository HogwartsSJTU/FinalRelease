import 'package:Hogwarts/component/chat/user_model.dart';

class Message {
  User sender;
  String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  String text;
  bool isLiked;
  bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'https://p.qqan.com/up/2020-9/2020941050205581.jpg',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Greg',
  imageUrl: 'assets/images/greg.jpg',
);
final User zyt = User(
  id: 2,
  name: 'zyt',
  imageUrl: 'https://p.qqan.com/up/2020-4/2020040708065325983.jpg',
);
final User lyb = User(
  id: 3,
  name: 'lyb',
  imageUrl: 'https://p.qqan.com/up/2020-3/2020032421312988009.jpg',
);
final User gdy = User(
  id: 4,
  name: 'gdy',
  imageUrl: 'https://p.qqan.com/up/2020-8/2020826954544309.png',
);
final User sqy = User(
  id: 5,
  name: 'sqy',
  imageUrl: 'https://p.qqan.com/up/2020-9/202091105822767.jpg',
);
final User sophia = User(
  id: 6,
  name: '林',
  imageUrl: 'assets/images/sophia.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [sqy, zyt, lyb, gdy];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: zyt,
    time: '5:30 PM',
    text: '下周一去霍体打羽毛球吗',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: gdy,
    time: '4:30 PM',
    text: '你的作业做完了吗',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: lyb,
    time: '3:30 PM',
    text: '昨天的作业咋做啊',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: zyt,
    time: '5:30 PM',
    text: '下周一去霍体打羽毛球吗',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: gdy,
    time: '4:30 PM',
    text: '你的作业做完了吗',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: lyb,
    time: '3:30 PM',
    text: '昨天的作业咋做啊',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: currentUser,
    time: '3:00 PM',
    text: '最近有什么安排啊',
    isLiked: false,
    unread: false,
  ),
//  Message(
//    sender: zyt,
//    time: '5:30 PM',
//    text: 'Hey, how\'s it going? What did you do today?',
//    isLiked: true,
//    unread: true,
//  ),
//  Message(
//    sender: currentUser,
//    time: '4:30 PM',
//    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '3:45 PM',
//    text: 'How\'s the doggo?',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '3:15 PM',
//    text: 'All the food',
//    isLiked: true,
//    unread: true,
//  ),
//  Message(
//    sender: currentUser,
//    time: '2:30 PM',
//    text: 'Nice! What kind of food did you eat?',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '2:00 PM',
//    text: 'I ate so much food today.',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '5:30 PM',
//    text: 'Hey, how\'s it going? What did you do today?',
//    isLiked: true,
//    unread: true,
//  ),
//  Message(
//    sender: currentUser,
//    time: '4:30 PM',
//    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '3:45 PM',
//    text: 'How\'s the doggo?',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '3:15 PM',
//    text: 'All the food',
//    isLiked: true,
//    unread: true,
//  ),
//  Message(
//    sender: currentUser,
//    time: '2:30 PM',
//    text: 'Nice! What kind of food did you eat?',
//    isLiked: false,
//    unread: true,
//  ),
//  Message(
//    sender: zyt,
//    time: '2:00 PM',
//    text: 'I ate so much food today.',
//    isLiked: false,
//    unread: true,
//  ),
];

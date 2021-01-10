import 'package:Hogwarts/utils/StorageUtil.dart';

class Account {
  static saveToken(response) {
    StorageUtil.setStringItem("token", response);
  }
  static saveUserInfo(response) {
    List<String> resToSL(res) {
      int l = res.length;
      List<String> ans = new List();
      for (int i = 0; i < l; i++) {
        ans.add(res[i].toString());
      }
      return ans;
    }

    StorageUtil.setStringItem("email", response["email"]);
    StorageUtil.setStringItem("phone", response["phone"]);
    StorageUtil.setStringItem("username", response["name"]);
    StorageUtil.setStringItem("userIcon", response["icon"]);
    StorageUtil.setIntItem("uid", response["id"]);
    StorageUtil.setStringItem("address", response["address"]);
    StorageUtil.setStringItem("time", response["time"]);
    StorageUtil.setIntItem("age", response["age"]);
    StorageUtil.setStringItem("gender", response["gender"]);
    StorageUtil.setStringItem("desc", response["description"]);
    StorageUtil.setIntItem("role", response["role"]);
//    StorageUtil.setStringListItem("skills", resToSL(response["skills"]));
  }

  static saveUserSkill(response) {
    List<String> resToSL(res) {
      int l = res.length;
      List<String> ans = new List();
      for (int i = 0; i < l; i++) {
        ans.add(res[i].toString());
      }
      return ans;
    }

    StorageUtil.setStringListItem("skills", resToSL(response["skills"]));
  }

  static delUserInfo() {
    StorageUtil.clear();
  }
}

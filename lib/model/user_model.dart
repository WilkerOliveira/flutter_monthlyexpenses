import 'package:mobx/mobx.dart';

part 'user_model.g.dart';

class UserModel = UserModelBase with _$UserModel;

abstract class UserModelBase with Store {
  String userID;
  @observable
  String firstName;
  @observable
  String email;
  String password;
  String confirmPassword;
  String customLogin;
  String oldPassword;

  @action
  setFirstName(String name) => this.firstName = name;

  @action
  setEmail(String email) => this.email = email;

  UserModelBase({
    this.userID,
    this.firstName,
    this.email,
    this.customLogin,
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'email': email == null ? '' : email,
      'customLogin': customLogin,
    };
  }

  @action
  fromJson(Map<String, Object> doc) {
    this.userID = doc['userID'];
    this.firstName = doc['firstName'];
    this.email = doc['email'];
    this.customLogin = doc['customLogin'];
  }

  UserModelBase.fromDb(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        customLogin = map['customLogin'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['userID'] = userID;
    map['email'] = email;
    map['customLogin'] = customLogin;

    return map;
  }
}

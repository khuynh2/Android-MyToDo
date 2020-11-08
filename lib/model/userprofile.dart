class User {
  // field name for firestore mapping
  static const COLLECTION = 'userProfile';
  static const USERNAME = 'userName';
  static const EMAIL = 'email';
  static const USER_IMAGE = 'userImage';
  static const USER_ROLE = 'userRole';

  String userId;
  String userName;
  String email;
  String userImage;
  String userRole;

  User({this.userId, this.userName, this.email, this.userImage, this.userRole});

  //map dart to fb
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      USERNAME: userName,
      EMAIL: email,
      USER_IMAGE: userImage,
      USER_ROLE: userRole,
    };
  }
}

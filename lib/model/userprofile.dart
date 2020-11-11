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

  //map User dart to fb
  Map<String, dynamic> serializeUser() {
    return <String, dynamic>{
      USERNAME: userName,
      EMAIL: email,
      USER_IMAGE: userImage,
      USER_ROLE: userRole,
    };
  }

  static User deserializeUser(Map<String, dynamic> data, String docId) {
    return User(
      userId: docId,
      email: data[User.EMAIL],
      userName: data[User.USERNAME],
      userImage: data[User.USER_IMAGE],
      userRole: data[User.USER_ROLE],
    );
  }
}

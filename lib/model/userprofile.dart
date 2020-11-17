class User {
  // field name for firestore mapping
  static const COLLECTION = 'userProfile';
  static const USERNAME = 'userName';
  static const EMAIL = 'email';
  static const USER_IMAGE = 'userImage';
  static const IMAGE_URL = 'userImageURL';
  static const USER_ROLE = 'userRole';

  String userId;
  String userName;
  String email;
  String userImage; //path to image
  String userImageURL; //url for internet access
  String userRole;

  User(
      {this.userId,
      this.userName,
      this.email,
      this.userImage,
      this.userRole,
      this.userImageURL});

  //map User dart to fb
  Map<String, dynamic> serializeUser() {
    return <String, dynamic>{
      USERNAME: userName,
      EMAIL: email,
      USER_IMAGE: userImage,
      IMAGE_URL: userImageURL,
      USER_ROLE: userRole,
    };
  }

  static User deserializeUser(Map<String, dynamic> data, String docId) {
    return User(
      userId: docId,
      email: data[User.EMAIL],
      userName: data[User.USERNAME],
      userImage: data[User.USER_IMAGE],
      userImageURL: data[User.IMAGE_URL],
      userRole: data[User.USER_ROLE],
    );
  }
}

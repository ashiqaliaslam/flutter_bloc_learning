// @immutable
// class UserInfoStorage {
//   const UserInfoStorage();

//   Future<bool> saveUserInfo({
//     required UserId userId,
//     required String displayName,
//     required String? email,
//     required String? photoURL,
//   }) async {
//     try {
//       final userInfo = await FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.users)
//           .where(FirebaseFieldName.userId, isEqualTo: userId)
//           .limit(1)
//           .get();

//       if (userInfo.docs.isNotEmpty) {
//         await userInfo.docs.first.reference.update({
//           FirebaseFieldName.displayName: displayName,
//           FirebaseFieldName.email: email ?? '',
//           FirebaseFieldName.photoURL: photoURL ?? '',
//         });

//         return true;
//       }

//       final payload = UserInfoPayload(
//         userId: userId,
//         displayName: displayName,
//         email: email,
//         photoURL: photoURL,
//       );

//       await FirebaseFirestore.instance
//           .collection(FirebaseCollectionName.users)
//           .add(payload);

//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
// }

// @immutable
// class UserInfoPayload extends MapView<String, dynamic> {
//   UserInfoPayload({
//     required UserId userId,
//     required String? displayName,
//     required String? email,
//     required String? photoURL,
//   }) : super({
//           FirebaseFieldName.userId: userId,
//           FirebaseFieldName.displayName: displayName ?? '',
//           FirebaseFieldName.email: email ?? '',
//           FirebaseFieldName.photoURL: photoURL ?? '',
//         });
// }

// @immutable
// class UserInfo extends MapView<String, dynamic> with EquatableMixin {
//   final UserId userId;
//   final String displayName;
//   final String? email;
//   final String? photoURL;

//   UserInfo({
//     required this.userId,
//     required this.displayName,
//     required this.email,
//     required this.photoURL,
//   }) : super({
//           FirebaseFieldName.userId: userId,
//           FirebaseFieldName.displayName: displayName,
//           FirebaseFieldName.email: email,
//           FirebaseFieldName.photoURL: photoURL,
//         });

//   UserInfo.fromJson(
//     Map<String, dynamic> json, {
//     required UserId userId,
//   }) : this(
//           userId: userId,
//           displayName: json[FirebaseFieldName.displayName] ?? '',
//           email: json[FirebaseFieldName.email],
//           photoURL: json[FirebaseFieldName.photoURL],
//         );

//   @override
//   List<Object?> get props => [userId, displayName, email, photoURL];
// }

// final userInfoProvider =
//     StreamProvider.family.autoDispose<UserInfo, UserId>((ref, UserId userId) {
//   final controller = StreamController<UserInfo>();

//   final sub = FirebaseFirestore.instance
//       .collection(FirebaseCollectionName.users)
//       .where(FirebaseFieldName.userId, isEqualTo: userId)
//       .limit(1)
//       .snapshots()
//       .listen((snapshot) {
//     if (snapshot.docs.isNotEmpty) {
//       final doc = snapshot.docs.first;
//       final json = doc.data();
//       final userInfo = UserInfo.fromJson(
//         json,
//         userId: userId,
//       );
//       controller.add(userInfo);
//     }
//   });

//   ref.onDispose(() {
//     sub.cancel();
//     controller.close();
//   });

//   return controller.stream;
// });

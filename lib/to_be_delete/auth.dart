// enum AuthResult {
//   aborted,
//   success,
//   failure,
// }

// class Authenticator {
//   const Authenticator();

//   bool get isAlreadyLoggedIn => userId != null;
//   bool get emailVerified =>
//       FirebaseAuth.instance.currentUser?.emailVerified ?? false;
//   UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
//   dynamic get currentUser => FirebaseAuth.instance.currentUser;
//   String get displayName =>
//       FirebaseAuth.instance.currentUser?.displayName ?? '';
//   dynamic get photoUrl => FirebaseAuth.instance.currentUser?.photoURL ?? '';
//   String get email => FirebaseAuth.instance.currentUser?.email ?? '';

//   Future<void> logOut() async {
//     await FirebaseAuth.instance.signOut();
//     await GoogleSignIn().signOut();
//   }

//   Future<AuthResult> loginWithGoogle() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       scopes: [
//         Constants.emailScope,
//       ],
//     );
//     final signInAccount = await googleSignIn.signIn();
//     if (signInAccount == null) {
//       return AuthResult.aborted;
//     }

//     final googleAuth = await signInAccount.authentication;
//     final oauthCredentials = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken,
//       accessToken: googleAuth.accessToken,
//     );
//     try {
//       await FirebaseAuth.instance.signInWithCredential(
//         oauthCredentials,
//       );
//       return AuthResult.success;
//     } catch (e) {
//       return AuthResult.failure;
//     }
//   }
// }

// @immutable
// class Constants {
//   static const accountExistsWithDifferentCredential =
//       'account-exists-with-different-credentials';
//   static const googleCom = 'google.com';
//   static const emailScope = 'email';
//   const Constants._();
// }

// @immutable
// class UserAuthState extends Equatable {
//   final AuthResult? result;
//   final bool isLoading;
//   final UserId? userId;
//   final bool emailVerified;

//   const UserAuthState({
//     required this.result,
//     required this.isLoading,
//     required this.userId,
//     required this.emailVerified,
//   });

//   const UserAuthState.unKnown()
//       : result = null,
//         isLoading = false,
//         userId = null,
//         emailVerified = false;

//   UserAuthState copiedWithIsLoading(bool isLoading) => UserAuthState(
//         result: result,
//         isLoading: isLoading,
//         userId: userId,
//         emailVerified: emailVerified,
//       );

//   @override
//   List<Object?> get props => [result, isLoading, userId, emailVerified];
// }

// class AppStateNotifier extends StateNotifier<UserAuthState> {
//   final _authenticator = const Authenticator();
//   final _userInfoStorage = const UserInfoStorage();

//   get authenticator => _authenticator;

//   AppStateNotifier() : super(const UserAuthState.unKnown()) {
//     if (_authenticator.isAlreadyLoggedIn) {
//       state = UserAuthState(
//         result: AuthResult.success,
//         isLoading: false,
//         userId: _authenticator.userId,
//         emailVerified: false,
//       );
//     }
//   }

//   Future<void> logOut() async {
//     state = state.copiedWithIsLoading(true);
//     await _authenticator.logOut();
//     state = const UserAuthState.unKnown();
//     // rootNavigatorKey.currentState?.pushReplacementNamed('/'); // TODO: trial
//   }

//   Future<void> loginWithGoogle() async {
//     state = state.copiedWithIsLoading(true);
//     final result = await _authenticator.loginWithGoogle();
//     final userId = _authenticator.userId;
//     if (result == AuthResult.success && userId != null) {
//       await saveUserInfo(userId: userId);
//     }
//     state = UserAuthState(
//       result: result,
//       isLoading: false,
//       userId: _authenticator.userId,
//       emailVerified: _authenticator.emailVerified,
//     );
//   }

//   Future<void> refreshLoggedInUser() async {
//     state = state.copiedWithIsLoading(true);

//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       return;
//     }

//     await currentUser.reload();
//     state = state.copiedWithIsLoading(false);
//   }

//   Future<void> saveUserInfo({required UserId userId}) =>
//       _userInfoStorage.saveUserInfo(
//         userId: userId,
//         displayName: _authenticator.displayName,
//         email: _authenticator.email,
//         photoURL: _authenticator.photoUrl,
//       );
// }

// final authStateProvider =
//     StateNotifierProvider<AppStateNotifier, UserAuthState>(
//         (ref) => AppStateNotifier());

// final authenticatedUserProvider =
//     Provider((ref) => ref.watch(authStateProvider.notifier).authenticator);

// final isLoggedInProvider = Provider<bool>((ref) {
//   final authState = ref.watch(authStateProvider);
//   return authState.result == AuthResult.success;
// });

// final userIdProvider =
//     Provider<UserId?>((ref) => ref.watch(authStateProvider).userId);

// typedef UserId = String;

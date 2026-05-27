class AppRoutePath {
  const AppRoutePath({this.isMoneyScreen = true});

  final bool isMoneyScreen;

  AppRoutePath copyWith({bool? isMoneyScreen}) {
    return AppRoutePath(isMoneyScreen: isMoneyScreen ?? this.isMoneyScreen);
  }
}

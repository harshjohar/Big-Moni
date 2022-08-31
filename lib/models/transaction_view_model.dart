class TransactionViewModel {
  // member of the list on the homescreen
  final String name;
  final String money;
  final String photoUrl;
  final String otherUserUid; // works are description for Profile screen.

  TransactionViewModel({
    required this.name,
    required this.money,
    required this.photoUrl,
    required this.otherUserUid,
  });
}

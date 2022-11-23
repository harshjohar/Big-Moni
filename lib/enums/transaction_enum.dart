enum TransactionEnum {
  credit('credit'),
  idk('idk'),
  debit('debit');

  const TransactionEnum(this.type);

  final String type;
}

extension ConvertTransaction on String {
  TransactionEnum toEnum() {
    switch (this) {
      case "credit":
        return TransactionEnum.credit;
      case "debit":
        return TransactionEnum.debit;
      default:
        return TransactionEnum.idk;
    }
  }
}

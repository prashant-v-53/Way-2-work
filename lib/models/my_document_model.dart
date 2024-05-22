class MyDocModel {
  final String id;
  final String fileName;
  final String title;
  final String expiryDate;
  final String startDate;
  final String docType;
  final bool isExpired;
  final bool isDelete;
  bool isExpanded;
  MyDocModel({
    this.id,
    this.fileName,
    this.title,
    this.expiryDate,
    this.startDate,
    this.docType,
    this.isExpired,
    this.isDelete,
    this.isExpanded,
  });
}

class ContractModel {
  final String id;
  final String fileName;
  final String employerId;
  final String contractName;
  final String documentName;
  final String expiryDate;
  bool isExpanded;
  ContractModel({
    this.id,
    this.fileName,
    this.employerId,
    this.contractName,
    this.documentName,
    this.expiryDate,
    this.isExpanded,
  });
}

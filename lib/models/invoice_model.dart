class InvoiceModel {
  final String id;
  final String creationDate;
  final String dueDate;
  final String invoiceId;
  final String invoiceTo;
  final String status;
  final String paidStatus;
  InvoiceModel({
    this.id,
    this.creationDate,
    this.dueDate,
    this.invoiceId,
    this.invoiceTo,
    this.status,
    this.paidStatus,
  });
}

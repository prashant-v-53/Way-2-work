class PaymentInvoice {
  final String id;
  final String name;
  final String isDuplicate;
  final String invoiceId;
  final String seekerId;
  final String employerId;
  final String contractType;
  final String contractValue;
  final String tax;
  final String dueDate;
  final String vat;
  final String status;
  final String paidStatus;
  final String verified;
  final String currency;
  final String createdAt;
  final String invoiceNumber;
  final String invoiceReference;
  final String payToAcc;
  final String invoiceTotal;

  PaymentInvoice({
    this.isDuplicate,
    this.seekerId,
    this.employerId,
    this.contractType,
    this.tax,
    this.dueDate,
    this.vat,
    this.status,
    this.paidStatus,
    this.verified,
    this.currency,
    this.invoiceId,
    this.contractValue,
    this.invoiceNumber,
    this.id,
    this.name,
    this.createdAt,
    this.invoiceReference,
    this.payToAcc,
    this.invoiceTotal,
  });

  factory PaymentInvoice.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      return PaymentInvoice(
        id: validate(jsonMap['id'].toString()),
        isDuplicate: validate(jsonMap['is_duplicate'].toString()),
        invoiceId: validate(jsonMap['invoice_id'].toString()),
        seekerId: validate(jsonMap['seeker_id'].toString()),
        contractType: validate(jsonMap['contract_type'].toString()),
        contractValue: validate(jsonMap['contract_value'].toString()),
        employerId: validate(jsonMap['employer_id'].toString()),
        tax: validate(jsonMap['tax'].toString()),
        dueDate: validate(jsonMap['due_date'].toString()),
        vat: validate(jsonMap['vat'].toString()),
        createdAt: validate(jsonMap['created_at'].toString()),
        status: validate(jsonMap['status'].toString()),
        paidStatus: validate(jsonMap['paid_status'].toString()),
        verified: validate(jsonMap['verified'].toString()),
        invoiceNumber: validate(jsonMap['invoice_number'].toString()),
        invoiceReference: validateCompany(jsonMap['employer']),
        currency: validate(jsonMap['review'].toString()),
        name: validate(jsonMap['invoice_id'].toString()),
        invoiceTotal: validate(jsonMap['invoice_total'].toString()),
        payToAcc: validate(jsonMap['pay_to_acc'].toString()),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String validate(String val) {
    if (val == null || val == 'null' || val == '') {
      return '-';
    } else {
      return val;
    }
  }

  static String validateCompany(val) {
    if (val == null || val == '' || val == 0) {
      return '-';
    } else {
      if (val['company_name'] == null || val['company_name'] == '')
        return val['first_name'] ?? '' + val['last_name'] ?? '';
      else
        return val['company_name'];
    }
  }
}

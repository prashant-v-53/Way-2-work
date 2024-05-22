import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:way_to_work/l10n/messages_all.dart';

class Translations {
  static Future<Translations> load(Locale locale) {
    final String name =
        (locale.countryCode != null && locale.countryCode.isEmpty)
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((dynamic _) {
      Intl.defaultLocale = localeName;
      return new Translations();
    });
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String get appName {
    return Intl.message(
      'Way 2 Work',
      name: 'appName',
    );
  }

  String get languageName {
    return Intl.message(
      'English',
      name: 'languageName',
    );
  }

  String get enterValidEmail {
    return Intl.message(
      "Enter valid email",
      name: 'enterValidEmail',
    );
  }

  String get enterValidPassword {
    return Intl.message(
      "Enter valid password",
      name: 'enterValidPassword',
    );
  }

  String get checkYourEmailNow {
    return Intl.message(
      "Check your email now",
      name: 'checkYourEmailNow',
    );
  }

  String get enterValidTaxNo {
    return Intl.message(
      "Enter valid tax number",
      name: 'enterValidTaxNo',
    );
  }

  String get enterValidSsnNo {
    return Intl.message(
      "Enter valid SSN number",
      name: 'enterValidSsnNo',
    );
  }

  String get enterValidFullName {
    return Intl.message(
      "Enter valid full name",
      name: 'enterValidFullName',
    );
  }

  String get eitherSSNorYTunnusShouldBeprovided {
    return Intl.message(
      "Either SSN or Y-Tunnus should be provided",
      name: 'eitherSSNorYTunnusShouldBeprovided',
    );
  }

  String get pleaseSelectDate {
    return Intl.message(
      "Please select date",
      name: 'pleaseSelectDate',
    );
  }

  String get updatedSuccessfully {
    return Intl.message(
      "Updated Successfully",
      name: 'updatedSuccessfully',
    );
  }

  String get addWorkSucessfully {
    return Intl.message(
      "Add work successfully",
      name: 'addWorkSucessfully',
    );
  }

  String get deletedSuccessfully {
    return Intl.message(
      "Deleted Successfully",
      name: 'deletedSuccessfully',
    );
  }

  String get noImageSelected {
    return Intl.message(
      "No image selected",
      name: 'noImageSelected',
    );
  }

  String get contractValueNotGraterThanTotalWorkValue {
    return Intl.message(
      "Contract value not grater than total work value",
      name: 'contractValueNotGraterThanTotalWorkValue',
    );
  }

  String get invoiceCreatedSuccessfully {
    return Intl.message(
      "Invoice created successfully",
      name: 'invoiceCreatedSuccessfully',
    );
  }

  String get alert {
    return Intl.message(
      "Alert!",
      name: 'alert',
    );
  }

  String get areYouSureWantToLogout {
    return Intl.message(
      "Are you sure want to logout?",
      name: 'areYouSureWantToLogout',
    );
  }

  String get ok {
    return Intl.message(
      "Ok",
      name: 'ok',
    );
  }

  String get no {
    return Intl.message(
      "No",
      name: 'no',
    );
  }

  String get pleaseOnlySelectPieces {
    return Intl.message(
      "Please only select pieces",
      name: 'pleaseOnlySelectPieces',
    );
  }

  String get pleaseOnlySelectHours {
    return Intl.message(
      "Please only select hours",
      name: 'pleaseOnlySelectHours',
    );
  }

  String get selectAtleastOneWorkedHour {
    return Intl.message(
      "Select atleast one worked hour",
      name: 'selectAtleastOneWorkedHour',
    );
  }

  String get insuranceService {
    return Intl.message(
      "Insurance Service",
      name: 'insuranceService',
    );
  }

  String get insuranceNumber {
    return Intl.message(
      "Insurance Number",
      name: 'insuranceNumber',
    );
  }

  String get insuranceEmail {
    return Intl.message(
      "Insurance Email",
      name: 'insuranceEmail',
    );
  }

  String get website {
    return Intl.message(
      "Website",
      name: 'website',
    );
  }

  String get package {
    return Intl.message(
      "Package",
      name: 'package',
    );
  }

  String get action {
    return Intl.message(
      "Action",
      name: 'action',
    );
  }

  String get pressAgainToExitApp {
    return Intl.message(
      "Press again to exit app",
      name: 'pressAgainToExitApp',
    );
  }

  String get email {
    return Intl.message(
      "Email",
      name: 'email',
    );
  }

  String get password {
    return Intl.message(
      "Password",
      name: 'password',
    );
  }

  String get signup {
    return Intl.message(
      "Sign up",
      name: 'signup',
    );
  }

  String get fullName {
    return Intl.message(
      "Full Name",
      name: 'fullName',
    );
  }

  String get taxNumber {
    return Intl.message(
      "Tax Number",
      name: 'taxNumber',
    );
  }

  String get next {
    return Intl.message(
      "Next",
      name: 'next',
    );
  }

  String get addWorkDetails {
    return Intl.message(
      "Add work details",
      name: 'addWorkDetails',
    );
  }

  String get contractType {
    return Intl.message(
      "Contract Type",
      name: 'contractType',
    );
  }

  String get date {
    return Intl.message(
      "Date",
      name: 'date',
    );
  }

  String get tripStart {
    return Intl.message(
      "Trip Start",
      name: 'tripStart',
    );
  }

  String get tripEnds {
    return Intl.message(
      "Trip Ends",
      name: 'tripEnds',
    );
  }

  String get tripAddresses {
    return Intl.message(
      "Trip Addresses",
      name: 'tripAddresses',
    );
  }

  String get numberOfHoursWorked {
    return Intl.message(
      "Number of hours worked",
      name: 'numberOfHoursWorked',
    );
  }

  String get numberOfPieces {
    return Intl.message(
      "Number of pieces",
      name: 'numberOfPieces',
    );
  }

  String get lunchCompensation {
    return Intl.message(
      "Lunch compensation",
      name: 'lunchCompensation',
    );
  }

  String get tripTime {
    return Intl.message(
      "Trip Time",
      name: 'tripTime',
    );
  }

  String get otherCompensations {
    return Intl.message(
      "Other Compensations",
      name: 'otherCompensations',
    );
  }

  String get workDescription {
    return Intl.message(
      "Work Description",
      name: 'workDescription',
    );
  }

  String get enterTripAddresses {
    return Intl.message(
      "Enter trip addresses",
      name: 'enterTripAddresses',
    );
  }

  String get enterKM {
    return Intl.message(
      "Enter KM",
      name: 'enterKM',
    );
  }

  String get enterAmount {
    return Intl.message(
      "Enter Amount",
      name: 'enterAmount',
    );
  }

  String get enterTripTime {
    return Intl.message(
      "Enter trip time",
      name: 'enterTripTime',
    );
  }

  String get enterHoursWorked {
    return Intl.message(
      "Enter hours worked",
      name: 'enterHoursWorked',
    );
  }

  String get enterPieces {
    return Intl.message(
      "Enter pieces",
      name: 'enterPieces',
    );
  }

  String get submit {
    return Intl.message(
      "Submit",
      name: 'submit',
    );
  }

  String get manage {
    return Intl.message(
      "Manage",
      name: 'manage',
    );
  }

  String get account {
    return Intl.message(
      "Account",
      name: 'account',
    );
  }

  String get updateProfile {
    return Intl.message(
      "Update Profile",
      name: 'updateProfile',
    );
  }

  String get gender {
    return Intl.message(
      "Gender",
      name: 'gender',
    );
  }

  String get dateOfBirth {
    return Intl.message(
      "Gender",
      name: 'dateOfBirth',
    );
  }

  String get currentAddress {
    return Intl.message(
      "Current Address",
      name: 'currentAddress',
    );
  }

  String get residence {
    return Intl.message(
      "Residence",
      name: 'residence',
    );
  }

  String get nationality {
    return Intl.message(
      "Nationality",
      name: 'nationality',
    );
  }

  String get mobilePhone {
    return Intl.message(
      "Mobile Phone",
      name: 'mobilePhone',
    );
  }

  String get homePhone {
    return Intl.message(
      "Home Phone",
      name: 'homePhone',
    );
  }

  String get dashboard {
    return Intl.message(
      "Dashboard",
      name: 'dashboard',
    );
  }

  String get invoices {
    return Intl.message(
      "Invoices",
      name: 'invoices',
    );
  }

  String get invite {
    return Intl.message(
      "Invite",
      name: 'invite',
    );
  }

  String get myCV {
    return Intl.message(
      "My CV",
      name: 'myCV',
    );
  }

  String get workPermit {
    return Intl.message(
      "Work Permit",
      name: 'workPermit',
    );
  }

  String get workContract {
    return Intl.message(
      "Work contract",
      name: 'workContract',
    );
  }

  String get edit {
    return Intl.message(
      "Edit",
      name: 'edit',
    );
  }

  String get socialSecurityNumber {
    return Intl.message(
      "Social Security Number",
      name: 'socialSecurityNumber',
    );
  }

  String get receive {
    return Intl.message(
      "Receive",
      name: 'receive',
    );
  }

  String get notification {
    return Intl.message(
      "Notification",
      name: 'notification',
    );
  }

  String get onn {
    return Intl.message(
      "On",
      name: 'onn',
    );
  }

  String get off {
    return Intl.message(
      "Off",
      name: 'off',
    );
  }

  String get shareLink {
    return Intl.message(
      "Share Link",
      name: 'shareLink',
    );
  }

  String get registerViaShareLinkReport {
    return Intl.message(
      "Register via share link report",
      name: 'registerViaShareLinkReport',
    );
  }

  String get proffesionalSummary {
    return Intl.message(
      "Proffesional Summary",
      name: 'proffesionalSummary',
    );
  }

  String get experience {
    return Intl.message(
      "Experience",
      name: 'experience',
    );
  }

  String get education {
    return Intl.message(
      "Education",
      name: 'education',
    );
  }

  String get myJobApplications {
    return Intl.message(
      "My Job Applications",
      name: 'myJobApplications',
    );
  }

  String get myAdditionalInformation {
    return Intl.message(
      "Additional Information",
      name: 'myAdditionalInformation',
    );
  }

  String get personalTax {
    return Intl.message(
      "Personal Tax(%)",
      name: 'personalTax',
    );
  }

  String get maxTaxpercentage {
    return Intl.message(
      "Max. Tax Percentage(%)",
      name: 'maxTaxpercentage',
    );
  }

  String get yearlyIncome {
    return Intl.message(
      "Yearly Income",
      name: 'yearlyIncome',
    );
  }

  String get bankAccInformation {
    return Intl.message(
      "Bank Account Information",
      name: 'bankAccInformation',
    );
  }

  String get bankName {
    return Intl.message(
      "Bank Name",
      name: 'bankName',
    );
  }

  String get accountNumber {
    return Intl.message(
      "Account Number",
      name: 'accountNumber',
    );
  }

  String get bicNumber {
    return Intl.message(
      "BIC Number",
      name: 'bicNumber',
    );
  }

  String get enterFullName {
    return Intl.message(
      "Enter full name",
      name: 'enterFullName',
    );
  }

  String get enterCurrentAddres {
    return Intl.message(
      "Enter current address",
      name: 'enterCurrentAddres',
    );
  }

  String get enterMobileNo {
    return Intl.message(
      "Enter mobile number",
      name: 'enterMobileNo',
    );
  }

  String get enterHomePhone {
    return Intl.message(
      "Enter home phone",
      name: 'enterHomePhone',
    );
  }

  String get enterPersonalTaxNumber {
    return Intl.message(
      "Enter personal tax number",
      name: 'enterPersonalTaxNumber',
    );
  }

  String get enterMaxTaxPercentage {
    return Intl.message(
      "Enter max tax percentage",
      name: 'enterMaxTaxPercentage',
    );
  }

  String get enterYearlyIncome {
    return Intl.message(
      "Enter yearly income",
      name: 'enterYearlyIncome',
    );
  }

  String get selectGender {
    return Intl.message(
      "Select Gender",
      name: 'selectGender',
    );
  }

  String get selectNationality {
    return Intl.message(
      "Select Nationality",
      name: 'selectNationality',
    );
  }

  String get update {
    return Intl.message(
      "Update",
      name: 'update',
    );
  }

  String get day {
    return Intl.message(
      "Day",
      name: 'day',
    );
  }

  String get month {
    return Intl.message(
      "Month",
      name: 'month',
    );
  }

  String get year {
    return Intl.message(
      "Year",
      name: 'year',
    );
  }

  String get addNewEmployers {
    return Intl.message(
      "Add new employers",
      name: 'addNewEmployers',
    );
  }

  String get nameOfEmployer {
    return Intl.message(
      "Name of employer",
      name: 'nameOfEmployer',
    );
  }

  String get employerTelephone {
    return Intl.message(
      "Employer Telephone",
      name: 'employerTelephone',
    );
  }

  String get employerSSN {
    return Intl.message(
      "Employer SSN",
      name: 'employerSSN',
    );
  }

  String get employerYTunnus {
    return Intl.message(
      "Employer Y-Tunnus",
      name: 'employerYTunnus',
    );
  }

  String get emailOfEmployer {
    return Intl.message(
      "Email of employer",
      name: 'emailOfEmployer',
    );
  }

  String get employerTaxNo {
    return Intl.message(
      "Employer tax number",
      name: 'employerTaxNo',
    );
  }

  String get addressOfEmploye {
    return Intl.message(
      "Address of Employer",
      name: 'addressOfEmploye',
    );
  }

  String get addAttachmentForReceipt {
    return Intl.message(
      "Add Attachment for Receipt",
      name: 'addAttachmentForReceipt',
    );
  }

  String get otherExpenses {
    return Intl.message(
      "Other Expenses",
      name: 'otherExpenses',
    );
  }

  String get otherFiles {
    return Intl.message(
      "Other Files",
      name: 'otherFiles',
    );
  }

  String get multipleFiles {
    return Intl.message(
      "Multiple Files",
      name: 'multipleFiles',
    );
  }

  String get reference {
    return Intl.message(
      "Reference",
      name: 'reference',
    );
  }

  String get explanation {
    return Intl.message(
      "Explanation",
      name: 'explanation',
    );
  }

  String get selectCountry {
    return Intl.message(
      "Select Country",
      name: 'selectCountry',
    );
  }

  String get city {
    return Intl.message(
      "City",
      name: 'city',
    );
  }

  String get worked {
    return Intl.message(
      "Worked",
      name: 'worked',
    );
  }

  String get hours {
    return Intl.message(
      "Hours",
      name: 'hours',
    );
  }

  String get pieces {
    return Intl.message(
      "Pieces",
      name: 'pieces',
    );
  }

  String get showingTotalEntries {
    return Intl.message(
      "Showing Total Entries",
      name: 'showingTotalEntries',
    );
  }

  String get createdOn {
    return Intl.message(
      "Worked Hours and Gigs",
      name: 'createdOn',
    );
  }

  String get workedHours {
    return Intl.message(
      "Worked Hours",
      name: 'workedHours',
    );
  }

  String get dailyCompensation {
    return Intl.message(
      "Daily Compensation",
      name: 'dailyCompensation',
    );
  }

  String get extraInformation {
    return Intl.message(
      "Extra Information",
      name: 'extraInformation',
    );
  }

  String get duplicate {
    return Intl.message(
      "Duplicate",
      name: 'duplicate',
    );
  }

  String get delete {
    return Intl.message(
      "Delete",
      name: 'delete',
    );
  }

  String get useInInvoice {
    return Intl.message(
      "Use in invoice",
      name: 'useInInvoice',
    );
  }

  String get employerDetails {
    return Intl.message(
      "Employer Details",
      name: 'employerDetails',
    );
  }

  String get dailyWorkDetails {
    return Intl.message(
      "Daily work details",
      name: 'dailyWorkDetails',
    );
  }

  String get invoiceData {
    return Intl.message(
      "Invoice Data",
      name: 'invoiceData',
    );
  }

  String get addValidEmployerDetails {
    return Intl.message(
      "Add valid employer details",
      name: 'addValidEmployerDetails',
    );
  }

  String get addValidDailyWorkDetails {
    return Intl.message(
      "Add valid daily work details",
      name: 'addValidDailyWorkDetails',
    );
  }

  String get modify {
    return Intl.message(
      "Modify",
      name: 'modify',
    );
  }

  String get addMore {
    return Intl.message(
      "Add More",
      name: 'addMore',
    );
  }

  String get contractValue {
    return Intl.message(
      "Contract Value",
      name: 'contractValue',
    );
  }

  String get taxVero {
    return Intl.message(
      "Tax Vero",
      name: 'taxVero',
    );
  }

  String get dueDate {
    return Intl.message(
      "Due Date",
      name: 'dueDate',
    );
  }

  String get chooseFile {
    return Intl.message(
      "Choose file",
      name: 'chooseFile',
    );
  }

  String get noFileChoose {
    return Intl.message(
      "No file choose",
      name: 'noFileChoose',
    );
  }

  String get name {
    return Intl.message(
      "Name",
      name: 'name',
    );
  }

  String get telephone {
    return Intl.message(
      "Telephone",
      name: 'telephone',
    );
  }

  String get address {
    return Intl.message(
      "Address",
      name: 'address',
    );
  }

  String get type {
    return Intl.message(
      "Type",
      name: 'type',
    );
  }

  String get addNew {
    return Intl.message(
      "Add New",
      name: 'addNew',
    );
  }

  String get creationDate {
    return Intl.message(
      "Creation Date",
      name: 'creationDate',
    );
  }

  String get invoiceId {
    return Intl.message(
      "Invoice ID",
      name: 'invoiceId',
    );
  }

  String get invoiceTo {
    return Intl.message(
      "Invoice To",
      name: 'invoiceTo',
    );
  }

  String get status {
    return Intl.message(
      "Status",
      name: 'status',
    );
  }

  String get paidStatus {
    return Intl.message(
      "Paid Status",
      name: 'paidStatus',
    );
  }

  String get view {
    return Intl.message(
      "View",
      name: 'view',
    );
  }

  String get payment {
    return Intl.message(
      "Payment",
      name: 'payment',
    );
  }

  String get anInvoiceWithCompensation {
    return Intl.message(
      "Invoice with compensations",
      name: 'anInvoiceWithCompensation',
    );
  }

  String get add {
    return Intl.message(
      "Add",
      name: 'add',
    );
  }

  String get myDashboard {
    return Intl.message(
      "My Dashboard",
      name: 'myDashboard',
    );
  }

  String get managePayment {
    return Intl.message(
      "Manage Payment",
      name: 'managePayment',
    );
  }

  String get manageAccount {
    return Intl.message(
      "Manage Account",
      name: 'manageAccount',
    );
  }

  String get enterContractValue {
    return Intl.message(
      "Enter contract value",
      name: 'enterContractValue',
    );
  }

  String get fullhalfdaycompensation {
    return Intl.message(
      "Full/Half day compensation",
      name: 'fullhalfdaycompensation',
    );
  }

  String get companyName {
    return Intl.message(
      "Company Name",
      name: 'companyName',
    );
  }

  String get savedAsDraft {
    return Intl.message(
      "Save as draft",
      name: 'savedAsDraft',
    );
  }

  String get invoiceSavedSuccessfully {
    return Intl.message(
      "Invoice saved successfully",
      name: 'invoiceSavedSuccessfully',
    );
  }

  String get distance {
    return Intl.message(
      "Distance",
      name: 'distance',
    );
  }

  String get makeInvoice {
    return Intl.message(
      "Make Invoice",
      name: 'makeInvoice',
    );
  }

  String get somethingWentToWrong {
    return Intl.message(
      "Something went to wrong !",
      name: 'somethingWentToWrong',
    );
  }

  String get noInternetConnection {
    return Intl.message(
      "No Internet Connection",
      name: 'noInternetConnection',
    );
  }

  String get camera {
    return Intl.message(
      "Camera",
      name: 'camera',
    );
  }

  String get file {
    return Intl.message(
      "File",
      name: 'file',
    );
  }

  String get imageDeletedSuccessfully {
    return Intl.message(
      "Image Deleted Successfully",
      name: 'imageDeletedSuccessfully',
    );
  }

  String get pleaseSelectEmployer {
    return Intl.message(
      "Please select employer",
      name: 'pleaseSelectEmployer',
    );
  }

  String get enterValidFileName {
    return Intl.message(
      "Enter valid file name",
      name: 'enterValidFileName',
    );
  }

  String get pleaseSelectExpiryDate {
    return Intl.message(
      "Please select expiry date",
      name: 'pleaseSelectExpiryDate',
    );
  }

  String get pleaseSelectFile {
    return Intl.message(
      "Please select file",
      name: 'pleaseSelectFile',
    );
  }

  String get workSafetyCard {
    return Intl.message(
      "Work Safety Card",
      name: 'workSafetyCard',
    );
  }

  String get idCard {
    return Intl.message(
      "ID Card",
      name: 'idCard',
    );
  }

  String get passport {
    return Intl.message(
      "Passport",
      name: 'passport',
    );
  }

  String get drivingLicense {
    return Intl.message(
      "Driving License",
      name: 'drivingLicense',
    );
  }

  String get residencePermit {
    return Intl.message(
      "Residence Permit",
      name: 'residencePermit',
    );
  }

  String get mycv {
    return Intl.message(
      "My CV",
      name: 'mycv',
    );
  }

  String get otherDocuments {
    return Intl.message(
      "Other Documents",
      name: 'otherDocuments',
    );
  }

  String get pleaseSelectDocumentType {
    return Intl.message(
      "Please select document type",
      name: 'pleaseSelectDocumentType',
    );
  }

  String get enterValidYearlyIncome {
    return Intl.message(
      "Enter valid yearly income",
      name: 'enterValidYearlyIncome',
    );
  }

  String get enterValidPersonalTax {
    return Intl.message(
      "Enter valid personal tax",
      name: 'enterValidPersonalTax',
    );
  }

  String get enterValidMaxTaxPercentage {
    return Intl.message(
      "Enter valid max tax percentage",
      name: 'enterValidMaxTaxPercentage',
    );
  }

  String get pleaseSelectStartDate {
    return Intl.message(
      "Please select start date",
      name: 'pleaseSelectStartDate',
    );
  }

  String get filesAreNotSavedYet {
    return Intl.message(
      "Files aren't saved yet but,",
      name: 'filesAreNotSavedYet',
    );
  }

  String get draftSavedSuccessfully {
    return Intl.message(
      "Draft saved successfully",
      name: 'draftSavedSuccessfully',
    );
  }

  String get selectAreaOfField {
    return Intl.message(
      "Select area of field",
      name: 'selectAreaOfField',
    );
  }

  String get send {
    return Intl.message(
      "Send",
      name: 'send',
    );
  }

  String get insuranceRequestSentSuccessfully {
    return Intl.message(
      "Insurance request sent successfully",
      name: 'insuranceRequestSentSuccessfully',
    );
  }

  String get noInternet {
    return Intl.message(
      "No Internet",
      name: 'noInternet',
    );
  }

  String get checkYourInternetConnectionAndTryAgain {
    return Intl.message(
      "Check your internet connection and try again.",
      name: 'checkYourInternetConnectionAndTryAgain',
    );
  }

  String get insuranceName {
    return Intl.message(
      "Insurance Name",
      name: 'insuranceName',
    );
  }

  String get sendEmail {
    return Intl.message(
      "Send Email",
      name: 'sendEmail',
    );
  }

  String get yourName {
    return Intl.message(
      "Your Name",
      name: 'yourName',
    );
  }

  String get yourProffesion {
    return Intl.message(
      "Your Proffesion",
      name: 'yourProffesion',
    );
  }

  String get lightEntrepreneurSSN {
    return Intl.message(
      "Light Entrepreneur SSN",
      name: 'lightEntrepreneurSSN',
    );
  }

  String get yelApproximateSumFor2020 {
    return Intl.message(
      "YEL - approximate sum for 2020",
      name: 'yelApproximateSumFor2020',
    );
  }

  String get phone {
    return Intl.message(
      "Phone",
      name: 'phone',
    );
  }

  String get termsAndConditions {
    return Intl.message(
      "Terms And Conditions",
      name: 'termsAndConditions',
    );
  }

  String get selectLanguage {
    return Intl.message(
      "Select language",
      name: 'selectLanguage',
    );
  }

  String get save {
    return Intl.message(
      "Save",
      name: 'save',
    );
  }

  String get incomeLevel {
    return Intl.message(
      "Income Level",
      name: 'incomeLevel',
    );
  }

  String get receiveDocument {
    return Intl.message(
      "Receive Document",
      name: 'receiveDocument',
    );
  }

  String get invoiceAmount {
    return Intl.message(
      "Invoice Amount",
      name: 'invoiceAmount',
    );
  }

  String get payToAccount {
    return Intl.message(
      "Paid to account",
      name: 'payToAccount',
    );
  }

  String get uploadContract {
    return Intl.message(
      "Upload Contract",
      name: 'uploadContract',
    );
  }

  String get selectEmployer {
    return Intl.message(
      "Select Employer",
      name: 'selectEmployer',
    );
  }

  String get fileName {
    return Intl.message(
      "File Name",
      name: 'fileName',
    );
  }

  String get expiryDate {
    return Intl.message(
      "Expiry Date",
      name: 'expiryDate',
    );
  }

  String get uploadFile {
    return Intl.message(
      "Upload File",
      name: 'uploadFile',
    );
  }

  String get employer {
    return Intl.message(
      "Employer",
      name: 'employer',
    );
  }

  String get employerEmail {
    return Intl.message(
      "Employer email",
      name: 'employerEmail',
    );
  }

  String get employerPhone {
    return Intl.message(
      "Employer phone",
      name: 'employerPhone',
    );
  }

  String get lightEntrepreneurEmail {
    return Intl.message(
      "Light Entrepreneur Email",
      name: 'lightEntrepreneurEmail',
    );
  }

  String get sentOn {
    return Intl.message(
      "Sent On",
      name: 'sentOn',
    );
  }

  String get documentTitle {
    return Intl.message(
      "Document Title",
      name: 'documentTitle',
    );
  }

  String get description {
    return Intl.message(
      "Description",
      name: 'description',
    );
  }

  String get viewFile {
    return Intl.message(
      "View File",
      name: 'viewFile',
    );
  }

  String get piecesValue {
    return Intl.message(
      "Pieces Value",
      name: 'piecesValue',
    );
  }

  String get hoursValue {
    return Intl.message(
      "Hour value",
      name: 'hoursValue',
    );
  }

  String get totalAmount {
    return Intl.message(
      "Total Amount",
      name: 'totalAmount',
    );
  }

  String get addMyDocument {
    return Intl.message(
      "Add my document",
      name: 'addMyDocument',
    );
  }

  String get documentType {
    return Intl.message(
      "Document Type",
      name: 'documentType',
    );
  }

  String get startDate {
    return Intl.message(
      "Start Date",
      name: 'startDate',
    );
  }

  String get documentName {
    return Intl.message(
      "Document Name",
      name: 'documentName',
    );
  }

  String get lightEntrepreneurPhone {
    return Intl.message(
      "Light Entrepreneur Phone",
      name: 'lightEntrepreneurPhone',
    );
  }

  String get lightEntrepreneurTaxNo {
    return Intl.message(
      "Light Entrepreneur Tax Number",
      name: 'lightEntrepreneurTaxNo',
    );
  }

  String get lightEntrepreneurBillingAddress {
    return Intl.message(
      "Light Entrepreneur Billing Address",
      name: 'lightEntrepreneurBillingAddress',
    );
  }

  String get invoicingEmail {
    return Intl.message(
      "Invoicing Email",
      name: 'invoicingEmail',
    );
  }

  String get worksiteAddress {
    return Intl.message(
      "Worksite Address",
      name: 'worksiteAddress',
    );
  }

  String get referenceNumber {
    return Intl.message(
      "Reference Number",
      name: 'referenceNumber',
    );
  }

  String get beginningOfWork {
    return Intl.message(
      "Beginning of work",
      name: 'beginningOfWork',
    );
  }

  String get workFinishedOn {
    return Intl.message(
      "Work Finished On",
      name: 'workFinishedOn',
    );
  }

  String get billingInterval {
    return Intl.message(
      "Billing Interval",
      name: 'billingInterval',
    );
  }

  String get otherInformation {
    return Intl.message(
      "Other Information",
      name: 'otherInformation',
    );
  }

  String get invoicingBy {
    return Intl.message(
      "Invoicing by",
      name: 'invoicingBy',
    );
  }

  String get employerSignatute {
    return Intl.message(
      "Employer Signature",
      name: 'employerSignatute',
    );
  }

  String get lightEntrepreneurSignature {
    return Intl.message(
      "Light Entrepreneur Signature",
      name: 'lightEntrepreneurSignature',
    );
  }

  String get foodType {
    return Intl.message(
      "Food Type",
      name: 'foodType',
    );
  }

  String get foodValue {
    return Intl.message(
      "Food Value",
      name: 'foodValue',
    );
  }

  String get travellingType {
    return Intl.message(
      "Travelling Type",
      name: 'travellingType',
    );
  }

  String get travellingValue {
    return Intl.message(
      "Travelling Value",
      name: 'travellingValue',
    );
  }

  String get acceptedByLightEntrepreneur {
    return Intl.message(
      "Accepted by light entrepreneur",
      name: 'acceptedByLightEntrepreneur',
    );
  }

  String get contractByFile {
    return Intl.message(
      "Contract by file",
      name: 'contractByFile',
    );
  }

  String get myContract {
    return Intl.message(
      "My Contract",
      name: 'myContract',
    );
  }

  String get contractName {
    return Intl.message(
      "Contract Name",
      name: 'contractName',
    );
  }

  String get myDocument {
    return Intl.message(
      "Documents",
      name: 'myDocument',
    );
  }

  String get warningYouMustAddDocumentLike {
    return Intl.message(
      "Warning ! You must add document like",
      name: 'warningYouMustAddDocumentLike',
    );
  }

  String get eContract {
    return Intl.message(
      "E-Contract",
      name: 'eContract',
    );
  }

  String get download {
    return Intl.message(
      "Download",
      name: 'download',
    );
  }

  String get documentExpired {
    return Intl.message(
      "Document Expired",
      name: 'documentExpired',
    );
  }

  String get documentNotExpired {
    return Intl.message(
      "Document Not Expired",
      name: 'documentNotExpired',
    );
  }

  String get accept {
    return Intl.message(
      "Accept",
      name: 'accept',
    );
  }

  String get agree {
    return Intl.message(
      "Agree",
      name: 'agree',
    );
  }

  String get pending {
    return Intl.message(
      "Pending",
      name: 'pending',
    );
  }

  String get days {
    return Intl.message(
      "Days",
      name: 'days',
    );
  }

  String get approved {
    return Intl.message(
      "Approved",
      name: 'approved',
    );
  }

  String get notPaid {
    return Intl.message(
      "Not paid",
      name: 'notPaid',
    );
  }

  String get paid {
    return Intl.message(
      "Paid",
      name: 'paid',
    );
  }

  String get ssn {
    return Intl.message(
      "SSN",
      name: 'ssn',
    );
  }

  String get noEmployeeFound {
    return Intl.message(
      "No Employee Found",
      name: 'noEmployeeFound',
    );
  }

  String get contractOf {
    return Intl.message(
      "Contract Of",
      name: 'contractOf',
    );
  }

  String get select {
    return Intl.message(
      "Select",
      name: 'select',
    );
  }

  String get vat {
    return Intl.message(
      "VAT",
      name: 'vat',
    );
  }

  String get bruttoSalary {
    return Intl.message(
      "Brutto Salary",
      name: 'bruttoSalary',
    );
  }

  String get bulkAmount {
    return Intl.message(
      "Bulk Amount",
      name: 'bulkAmount',
    );
  }

  String get earnedSoFar {
    return Intl.message(
      "Earned so far",
      name: 'earnedSoFar',
    );
  }

  String get pleaseSelectGender {
    return Intl.message(
      "Please select gender",
      name: 'pleaseSelectGender',
    );
  }

  String get enterValidCurrentAddress {
    return Intl.message(
      "Enter valid current address",
      name: 'enterValidCurrentAddress',
    );
  }

  String get pleaseSelectCountry {
    return Intl.message(
      "Please select country",
      name: 'pleaseSelectCountry',
    );
  }

  String get enterValidCity {
    return Intl.message(
      "Enter valid city",
      name: 'enterValidCity',
    );
  }

  String get forgotPassword {
    return Intl.message(
      "Forgot Password",
      name: 'forgotPassword',
    );
  }

  String get firstName {
    return Intl.message(
      "First Name",
      name: 'firstName',
    );
  }

  String get lastName {
    return Intl.message(
      "Last Name",
      name: 'lastName',
    );
  }

  String get enterValidFirstName {
    return Intl.message(
      "Enter valid first name",
      name: 'enterValidFirstName',
    );
  }

  String get enterValidLastName {
    return Intl.message(
      "Enter valid last name",
      name: 'enterValidLastName',
    );
  }

  String get enterLastName {
    return Intl.message(
      "Enter Last Name",
      name: 'enterLastName',
    );
  }

  String get enterFirstName {
    return Intl.message(
      "Enter First Name",
      name: 'enterFirstName',
    );
  }

  String get tACPoint1 {
    return Intl.message(
      "",
      name: 'tACPoint1',
    );
  }

  String get taxCard {
    return Intl.message(
      "Tax Card",
      name: 'taxCard',
    );
  }

  String get foodCompensation {
    return Intl.message(
      "Food Compensation",
      name: 'foodCompensation',
    );
  }

  String get hoursWorked {
    return Intl.message(
      "Hours Worked",
      name: 'hoursWorked',
    );
  }

  String get amount {
    return Intl.message(
      "Amount",
      name: 'amount',
    );
  }

  String get contruction {
    return Intl.message(
      "Construction sector reverse charge AVL 8 c §",
      name: 'contruction',
    );
  }

  String get notSelected {
    return Intl.message(
      "not selected",
      name: 'notSelected',
    );
  }

  String get registerSuccessfull {
    return Intl.message(
      "Registration successful!  Your account is being reviewed.",
      name: 'registerSuccessfull',
    );
  }

  String get value {
    return Intl.message(
      "Value",
      name: 'value',
    );
  }

  String get workbook {
    return Intl.message(
      "Workbook",
      name: 'workbook',
    );
  }

  String get male {
    return Intl.message(
      "Male",
      name: 'male',
    );
  }

  String get female {
    return Intl.message(
      "Female",
      name: 'female',
    );
  }

  String get addDetails {
    return Intl.message(
      "Add details",
      name: 'addDetails',
    );
  }

  String get noInvoices {
    return Intl.message(
      "No invoices",
      name: 'noInvoices',
    );
  }

  String get enterValidConfirmPassword {
    return Intl.message(
      "Enter valid confirm password",
      name: 'enterValidConfirmPassword',
    );
  }

  String get confirmPassword {
    return Intl.message(
      "Confirm Password",
      name: 'confirmPassword',
    );
  }

  String get company {
    return Intl.message(
      "Company",
      name: 'company',
    );
  }

  String get client {
    return Intl.message(
      "Private customer",
      name: 'client',
    );
  }

  String get invoiceRecipient {
    return Intl.message(
      "Invoice Recipient",
      name: 'invoiceRecipient',
    );
  }

  String get workDetails {
    return Intl.message(
      "Work details",
      name: 'workDetails',
    );
  }

  String get pleaseAddOrUpdateYourTaxCard {
    return Intl.message(
      "Please Add or Update your Tax Card",
      name: 'pleaseAddOrUpdateYourTaxCard',
    );
  }

  String get distanceTravelled {
    return Intl.message(
      "Distance Travelled",
      name: 'distanceTravelled',
    );
  }

  String get construction {
    return Intl.message(
      "Construction",
      name: 'construction',
    );
  }

  String get cleaningServices {
    return Intl.message(
      "Cleaning Services",
      name: 'cleaningServices',
    );
  }

  String get transportationServices {
    return Intl.message(
      "Transportation Services",
      name: 'transportationServices',
    );
  }

  String get notInUse {
    return Intl.message(
      "Not In Use",
      name: 'notInUse',
    );
  }

  String get entervalidHoursvalue {
    return Intl.message(
      "Enter valid hours value",
      name: 'entervalidHoursvalue',
    );
  }

  String get enterValidPiecesvalue {
    return Intl.message(
      "Enter valid pieces value",
      name: 'enterValidPiecesvalue',
    );
  }

  String get enterValidKm {
    return Intl.message(
      "Enter valid km",
      name: 'enterValidKm',
    );
  }

  String get enterValidDocumentName {
    return Intl.message(
      "Enter valid document name",
      name: 'enterValidDocumentName',
    );
  }

  String get sendInvitation {
    return Intl.message(
      "Send Invitation",
      name: 'sendInvitation',
    );
  }

  String get link {
    return Intl.message(
      "Link",
      name: 'link',
    );
  }

  String get linkCopySuccessfully {
    return Intl.message(
      "Link copy successfully",
      name: 'linkCopySuccessfully',
    );
  }

  String get invitationLinkSentSuccessfully {
    return Intl.message(
      "Invitation link send successfully",
      name: 'invitationLinkSentSuccessfully',
    );
  }
}

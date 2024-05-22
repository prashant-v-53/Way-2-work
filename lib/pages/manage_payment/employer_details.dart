// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:way_to_work/locale/translation_strings.dart';
// import 'package:way_to_work/models/employer_list_model.dart';
// import 'package:way_to_work/controllers/manage_payement_controller.dart';

// class EmployerDetails extends StatefulWidget {
//   @override
//   _EmployerDetailsState createState() => _EmployerDetailsState();
// }

// class _EmployerDetailsState extends StateMVC<EmployerDetails> {
//   ManagePaymentController _con;
//   _EmployerDetailsState() : super(ManagePaymentController()) {
//     _con = controller;
//   }

//   @override
//   void initState() {
//     _con.getEmployerList();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _con.size = MediaQuery.of(context).size;
//     return _con.isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : Column(
//             children: [
//               _con.employerList.length == 0 || _con.employerList == null
//                   ? Container()
//                   : Column(
//                       children: [
//                         SizedBox(
//                           height: _con.size.height * 0.025,
//                         ),
//                         _selectCompany(),
//                         SizedBox(
//                           height: _con.size.height * 0.025,
//                         ),
//                         _title("${Translations.of(context).taxVero}", _con.name),
//                         _divider(),
//                         _title("${Translations.of(context).telephone}", _con.telephone),
//                         _divider(),
//                         _title("${Translations.of(context).email}", _con.email),
//                         _divider(),
//                         _title("Y-Tunnus", _con.yTunnus),
//                         _divider(),
//                         _title("SSN", _con.ssn),
//                         _divider(),
//                         _title("${Translations.of(context).taxNumber}", _con.taxNo),
//                         _divider(),
//                         _title("${Translations.of(context).address}", _con.address),
//                         _divider(),
//                         _title("${Translations.of(context).type}", _con.type),
//                         SizedBox(
//                           height: 35.0,
//                         ),
//                         _deleteSection(),
//                         _button(
//                           "${Translations.of(context).modify}",
//                           () => _con.editEmployeFunction(
//                             context,
//                             _con.currentEmployer.id,
//                           ),
//                         ),
//                       ],
//                     ),
//               SizedBox(height: 10),
//               _button(
//                 "${Translations.of(context).addNew}",
//                 () => _con.addEmployeFunction(context),
//               ),
//               SizedBox(height: 10),
//             ],
//           );
//   }

//   Widget _title(String first, String second) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: _con.size.width * 0.05,
//           vertical: _con.size.height * 0.01),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             first,
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           Text(
//             second,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _selectCompany() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.0),
//       child: Material(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             10.0,
//           ),
//         ),
//         elevation: 2.0,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//           child: DropdownButton(
//             underline: Container(),
//             isExpanded: true,
//             icon: Icon(
//               Icons.keyboard_arrow_down,
//             ),
//             items: _con.employerList.map<DropdownMenuItem<EmployerModel>>(
//               (EmployerModel e) {
//                 return DropdownMenuItem<EmployerModel>(
//                   child: Text(e.companyName),
//                   value: e,
//                 );
//               },
//             ).toList(),
//             onChanged: (EmployerModel employee) {
//               setState(() => _con.currentEmployer = employee);
//               _con.getEmployerDetails(employee.id);
//             },
//             value: _con.currentEmployer,
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _summary(String name) {
//   //   Size size = MediaQuery.of(context).size;
//   //   return Row(
//   //     crossAxisAlignment: CrossAxisAlignment.center,
//   //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //     children: [
//   //       Container(
//   //         margin: EdgeInsets.symmetric(horizontal: 5.0),
//   //         height: size.height * 0.005,
//   //         width: size.width / 9,
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(25.0),
//   //           color: Colors.red,
//   //         ),
//   //       ),
//   //       Text(
//   //         name,
//   //         style: TextStyle(
//   //           fontSize: 16,
//   //         ),
//   //       ),
//   //       Container(
//   //         margin: EdgeInsets.symmetric(horizontal: 5.0),
//   //         height: size.height * 0.005,
//   //         width: size.width / 1.9,
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(25.0),
//   //           color: Colors.red,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _incomeLevel() {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(10.0),
//   //       color: Colors.white,
//   //     ),
//   //     width: _con.size.width * 0.85,
//   //     padding: EdgeInsets.all(5.0),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: [
//   //         Container(
//   //           alignment: Alignment.center,
//   //           height: _con.size.height / 20,
//   //           width: _con.size.width / 5,
//   //           decoration: BoxDecoration(
//   //             borderRadius: BorderRadius.circular(10.0),
//   //             color: Colors.red,
//   //           ),
//   //           child: Text(
//   //             "28%",
//   //             style: TextStyle(color: Colors.white),
//   //           ),
//   //         ),
//   //         Text(
//   //           "Income Level  ",
//   //           style: TextStyle(
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _divider() {
//     return Divider(
//       color: Colors.white,
//       indent: 10.0,
//       endIndent: 10.0,
//       thickness: 1.5,
//     );
//   }

//   Widget _deleteSection() {
//     return Container(
//       // margin: EdgeInsets.symmetric(vertical: 15.0),
//       padding: EdgeInsets.all(10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ButtonTheme(
//           //   height: size.height * 0.06,
//           //   minWidth: size.height * 0.06,
//           //   shape: RoundedRectangleBorder(
//           //     borderRadius: BorderRadius.circular(10.0),
//           //   ),
//           //   buttonColor: Colors.red,
//           //   child: RaisedButton(
//           //     onPressed: () {},
//           //     child: Icon(
//           //       Icons.arrow_back_ios,
//           //       color: Colors.white,
//           //     ),
//           //   ),
//           // ),
//           ButtonTheme(
//             height: _con.size.height / 18.5,
//             minWidth: MediaQuery.of(context).size.width / 1.2,
//             child: FlatButton(
//               onPressed: () =>
//                   _con.deleteEmployerDetails(_con.currentEmployer.id, context),
//               child: Text("${Translations.of(context).delete}"),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 side: BorderSide(
//                   color: Colors.white,
//                   width: 2.0,
//                 ),
//               ),
//             ),
//           ),
//           // ButtonTheme(
//           //   height: size.height * 0.06,
//           //   minWidth: size.height * 0.06,
//           //   shape: RoundedRectangleBorder(
//           //     borderRadius: BorderRadius.circular(10.0),
//           //   ),
//           //   buttonColor: Colors.red,
//           //   child: RaisedButton(
//           //     onPressed: () {},
//           //     child: Icon(
//           //       Icons.arrow_forward_ios,
//           //       color: Colors.white,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _button(String name, Function onTap) {
//     return ButtonTheme(
//       height: _con.size.height / 18.5,
//       minWidth: MediaQuery.of(context).size.width / 1.18,
//       buttonColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: RaisedButton(
//         elevation: 2.0,
//         onPressed: onTap,
//         child: Text(
//           name,
//           style: TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

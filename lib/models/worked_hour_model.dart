class WorkedHourModel {
  String id;
  String date;
  bool isExpanded;
  bool isChecked;
  String fullDate;
  String type;
  String tripStart;
  String tripEnd;
  String tripAddress;
  String km;
  String tripTime;
  String workingHours;
  String dailyCompansations;
  String dayCompansations;
  String otherCompensation;
  String extraInformation;
  WorkedHourModel({
    this.id,
    this.date,
    this.isExpanded,
    this.isChecked,
    this.fullDate,
    this.type,
    this.tripStart,
    this.tripEnd,
    this.tripAddress,
    this.km,
    this.tripTime,
    this.workingHours,
    this.dailyCompansations,
    this.dayCompansations,
    this.otherCompensation,
    this.extraInformation,
  });
}

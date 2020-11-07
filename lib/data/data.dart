import 'dart:math';

import 'package:ResidInn/models/date_model.dart';
import 'package:ResidInn/models/event_type_model.dart';
import 'package:ResidInn/models/events_model.dart';

List<DateModel> getDates() {
  List<DateModel> dates = new List<DateModel>();
  DateModel dateModel = new DateModel();

  //1
  dateModel.date = "10";
  dateModel.weekDay = "Sun";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "11";
  dateModel.weekDay = "Mon";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "12";
  dateModel.weekDay = "Tue";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "13";
  dateModel.weekDay = "Wed";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "14";
  dateModel.weekDay = "Thu";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "15";
  dateModel.weekDay = "Fri";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "16";
  dateModel.weekDay = "Sat";
  dates.add(dateModel);

  dateModel = new DateModel();

  return dates;
}

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = new List();
  EventTypeModel eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/concert.png";
  eventModel.eventType = "Talks";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Annual Meet";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/sports.png";
  eventModel.eventType = "Sports ";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.imgAssetPath = "assets/sports.png";
  eventModel.eventType = "Sports11 ";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  return events;
}

List<EventsModel> getEvents() {
  List<EventsModel> events = new List<EventsModel>();
  EventsModel eventsModel = new EventsModel();

  //1
  eventsModel.imgeAssetPath = "assets/tileimg.png";
  eventsModel.date = "Sep 12, 2020";
  eventsModel.desc = "Talk on Covid 19  ";
  eventsModel.address = "XRVA-64";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //2
  eventsModel.imgeAssetPath = "assets/second.png";
  eventsModel.date = "Jan 12, 2021";
  eventsModel.desc = "Annual Meet 2021";
  eventsModel.address = "XRVA-13";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //3
  eventsModel.imgeAssetPath = "assets/music_event.png";
  eventsModel.date = "Feb 12, 2021";
  eventsModel.desc = "Sports Day 2021";
  eventsModel.address = "XRVA-44";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  return events;
}

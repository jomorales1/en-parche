class EventModel {
  String? title;
  String? start_time;
  String? place;
  String? organizer;
  String? image_url;
  String? image_name;
  String? event_date;
  String? description;


  EventModel({
    this.title,
    this.start_time,
    this.place,
    this.organizer,
    this.image_url,
    this.image_name,
    this.event_date,
    this.description,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    start_time = json['start_time'];
    place= json['place'];
    organizer= json['organizer'];
    image_url= json['image_url'];
    image_name= json['image_name'];
    event_date= json['event_date'];
    description= json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['start_time'] = start_time;
    data['place'] = place;
    data['organizer'] = organizer;
    data['image_url'] = image_url;
    data['image_name'] = image_name;
    data['event_date'] = event_date;
    data['description'] = description;
    return data;
  }
}
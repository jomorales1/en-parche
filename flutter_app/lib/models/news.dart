class NewsModel {
  String? title;
  String? author;
  String? category;
  String? city;
  String? image_url;
  String? image_name;
  String? news_url;
  String? date;
  String? description;


  NewsModel({
    this.title,
    this.author,
    this.category,
    this.city,
    this.image_url,
    this.image_name,
    this.news_url,
    this.date,
    this.description,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    category= json['category'];
    city= json['city'];
    image_url= json['image_url'];
    image_name= json['image_name'];
    news_url= json['news_url'];
    date= json['date'];
    description= json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['author'] = author;
    data['category'] = category;
    data['city'] = city;
    data['image_url'] = image_url;
    data['image_name'] = image_name;
    data['news_url'] = news_url;
    data['date'] = date;
    data['description'] = description;
    return data;
  }
}
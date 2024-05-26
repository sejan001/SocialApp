class PostModel {
  int? postId;
  int? userId;
  int? createdAt;
  String? title;
  String? description;
  List<Image>? image;
  List<PostLikedBy>? postLikedBy;

  PostModel(
      {this.postId,
      this.userId,
      this.createdAt,
      this.title,
      this.description,
      this.image,
      this.postLikedBy});

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    title = json['title'];
    description = json['description'];
    if (json['Image'] != null) {
      image = <Image>[];
      json['Image'].forEach((v) {
        image!.add(new Image.fromJson(v));
      });
    }
    if (json['Post_liked_by'] != null) {
      postLikedBy = <PostLikedBy>[];
      json['Post_liked_by'].forEach((v) {
        postLikedBy!.add(new PostLikedBy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.image != null) {
      data['Image'] = this.image!.map((v) => v.toJson()).toList();
    }
    if (this.postLikedBy != null) {
      data['Post_liked_by'] = this.postLikedBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  int? id;
  String? url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    url = json['Url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Url'] = this.url;
    return data;
  }
}

class PostLikedBy {
  int? userId;
  String? dateTime;

  PostLikedBy({this.userId, this.dateTime});

  PostLikedBy.fromJson(Map<String, dynamic> json) {
    userId = json['User_id'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_id'] = this.userId;
    data['dateTime'] = this.dateTime;
    return data;
  }
}

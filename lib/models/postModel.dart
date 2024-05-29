class PostModel {
  String? postId;
  String? username; 
  String? createdAt;
  String? title;
  String? description;
  String? imageUrl; 
  List<PostLikedBy>? postLikedBy;

  PostModel({
    this.postId,
    this.username, 
    this.createdAt,
    this.title,
    this.description,
    this.imageUrl, 
    this.postLikedBy,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    username = json['user_id']; 
    createdAt = json['created_at'];
    title = json['title'];
    description = json['description'];
    if (json['Image']!= null) {
      imageUrl = json['Image']['Url']; 
    }
    if (json['Post_liked_by']!= null) {
      postLikedBy = <PostLikedBy>[];
      json['Post_liked_by'].forEach((v) {
        postLikedBy!.add(PostLikedBy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['post_id'] = postId;
    data['user_id'] = username; // Updated to match the new field name
    data['created_at'] = createdAt;
    data['title'] = title;
    data['description'] = description;
    if (imageUrl!= null) {
      data['Image'] = {'Url': imageUrl}; // Assuming 'Image' is a map with a 'Url' key
    }
    if (postLikedBy!= null) {
      data['Post_liked_by'] = postLikedBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Removed the Image class since it's no longer needed

class PostLikedBy {
  String? username;
  String? dateTime;

  PostLikedBy({this.username, this.dateTime});

  PostLikedBy.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
    dateTime = json['DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Username'] = username;
    data['DateTime'] = dateTime;
    return data;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/posts.dart'; // Prilagodi putanju do svog Post modela

class PostService {
  const PostService();

  static final _url = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts'
  );

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(_url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server je vratio status ${response.statusCode}');
    } 

    // JSONPlaceholder vraća direktnu listu (niz) u tijelu odgovora
    final jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Post>> watchPosts() async* {
    while (true) {
      yield await fetchPosts();
      await Future.delayed(const Duration(minutes: 1));
    }
  }
}

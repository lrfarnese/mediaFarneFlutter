class FeedController{

  Future<List<String>> carregarFeed(String tokenAuth) async {
    return await _apiFeed(tokenAuth);
  }

  Future<List<String>> _apiFeed(String tokenAuth) async {
    await Future.delayed(const Duration(seconds: 1));


    return ['Post 1', 'Post 2', 'Post 3'];
  }

}
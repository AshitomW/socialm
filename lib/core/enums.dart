enum Thememode {
  light,
  dark,
}

enum UserScore {
  comment(score: 1),
  textPost(score: 2),
  linkPost(score: 3),
  imagePost(score: 4),
  awardPost(score: 5),
  deletePost(score: -1);

  final int score;
  const UserScore({required this.score});
}

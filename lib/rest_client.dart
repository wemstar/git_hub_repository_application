import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class RestClient {

  factory RestClient(Dio dio) = _RestClient;

  @GET("/search/repositories")
  Future<SearchRepositoriesResponse> getRepositories(@Query("q") String query);

  @GET("/repositories")
  Future<List<Repository>> getDefaultRepositories();
  
  @GET("/repos/{fullName}/issues")
  Future<List<RepositoryIssues>> getRepositoryIssues(@Path() String fullName);

  @GET("/repos/{fullName}/pulls")
  Future<List<RepositoryPulls>> getRepositoryPulls(@Path() String fullName);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchRepositoriesResponse {
  int totalCount;
  bool incompleteResults;
  List<Repository> items;

  SearchRepositoriesResponse({
    required this.totalCount,
    required this.incompleteResults,
    required this.items});

  factory SearchRepositoriesResponse.fromJson(Map<String, dynamic> json) => _$SearchRepositoriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchRepositoriesResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Repository extends Equatable {

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    this.description});

  int id;
  String name;
  String fullName;
  String? description;
  RepositoryOwner owner;

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

  @override
  List<Object?> get props => [id, name, fullName, description, owner];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RepositoryIssues extends Equatable {

  RepositoryIssues({
    required this.id,
    required this.state,
    required this.title,
    required this.user,
    this.body});

  int id;
  String state;
  String title;
  String? body;
  RepositoryOwner user;

  factory RepositoryIssues.fromJson(Map<String, dynamic> json) => _$RepositoryIssuesFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryIssuesToJson(this);

  @override
  List<Object?> get props => [id, state, title, body, user];

}

@JsonSerializable(fieldRename: FieldRename.snake)
class RepositoryPulls extends Equatable {

  RepositoryPulls({
    required this.id,
    required this.state,
    required this.title,
    required this.user,
    this.body});

  int id;
  String state;
  String title;
  String? body;
  RepositoryOwner user;

  factory RepositoryPulls.fromJson(Map<String, dynamic> json) => _$RepositoryPullsFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryPullsToJson(this);

  @override
  List<Object?> get props => [id, state, title, body, user];

}

@JsonSerializable(fieldRename: FieldRename.snake)
class RepositoryOwner extends Equatable {
  int id;
  String login;
  String avatarUrl;


  RepositoryOwner({
    required this.id,
    required this.login,
    required this.avatarUrl});

  factory RepositoryOwner.fromJson(Map<String, dynamic> json) => _$RepositoryOwnerFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryOwnerToJson(this);

  @override
  List<Object?> get props => [id, login, avatarUrl];

}
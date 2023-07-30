// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRepositoriesResponse _$SearchRepositoriesResponseFromJson(
        Map<String, dynamic> json) =>
    SearchRepositoriesResponse(
      totalCount: json['total_count'] as int,
      incompleteResults: json['incomplete_results'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => Repository.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchRepositoriesResponseToJson(
        SearchRepositoriesResponse instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'incomplete_results': instance.incompleteResults,
      'items': instance.items,
    };

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      owner: RepositoryOwner.fromJson(json['owner'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'description': instance.description,
      'owner': instance.owner,
    };

RepositoryIssues _$RepositoryIssuesFromJson(Map<String, dynamic> json) =>
    RepositoryIssues(
      id: json['id'] as int,
      state: json['state'] as String,
      title: json['title'] as String,
      user: RepositoryOwner.fromJson(json['user'] as Map<String, dynamic>),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$RepositoryIssuesToJson(RepositoryIssues instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'title': instance.title,
      'body': instance.body,
      'user': instance.user,
    };

RepositoryPulls _$RepositoryPullsFromJson(Map<String, dynamic> json) =>
    RepositoryPulls(
      id: json['id'] as int,
      state: json['state'] as String,
      title: json['title'] as String,
      user: RepositoryOwner.fromJson(json['user'] as Map<String, dynamic>),
      body: json['body'] as String?,
    );

Map<String, dynamic> _$RepositoryPullsToJson(RepositoryPulls instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': instance.state,
      'title': instance.title,
      'body': instance.body,
      'user': instance.user,
    };

RepositoryOwner _$RepositoryOwnerFromJson(Map<String, dynamic> json) =>
    RepositoryOwner(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );

Map<String, dynamic> _$RepositoryOwnerToJson(RepositoryOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.github.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<SearchRepositoriesResponse> getRepositories(query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'q': query};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchRepositoriesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/search/repositories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchRepositoriesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<List<Repository>> getDefaultRepositories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<Repository>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repositories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Repository.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<RepositoryIssues>> getRepositoryIssues(fullName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<RepositoryIssues>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repos/${fullName}/issues',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => RepositoryIssues.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<RepositoryPulls>> getRepositoryPulls(fullName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<RepositoryPulls>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/repos/${fullName}/pulls',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => RepositoryPulls.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

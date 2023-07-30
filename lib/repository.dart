import 'package:git_hub_repository_application/rest_client.dart';

class RepositoryListRepository {
  const RepositoryListRepository({
    required this.restClient});

  final RestClient restClient;

  Future<SearchRepositoriesResponse> getRepoList(String searchPhase) {
    return restClient.getRepositories(searchPhase);
  }

  Future<List<Repository>> getDefaultRepoList() {
    return restClient.getDefaultRepositories();
  }

  Future<List<RepositoryIssues>> getRepositoryIssues(String fullName) {
    return restClient.getRepositoryIssues(fullName);
  }

  Future<List<RepositoryPulls>> getRepositoryPulls(String fullName) {
    return restClient.getRepositoryPulls(fullName);
  }
}
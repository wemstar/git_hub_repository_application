import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_hub_repository_application/repository.dart';

import 'package:git_hub_repository_application/rest_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:git_hub_repository_application/repository_list/repository_list_bloc.dart';

import 'repository_list_bloc_test.mocks.dart';

@GenerateMocks([RepositoryListRepository])
void main() {
  test('Empty list test', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getDefaultRepoList())
        .thenAnswer((realInvocation) async => const []);
    RepositoryListBloc bloc = RepositoryListBloc(repository: repository)
      ..add(RefreshRepositories());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.loading),
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.success)
      ]),
    );
  });

  test('Empty search list  query', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getRepoList("abcd")).thenAnswer((realInvocation) async =>
        SearchRepositoriesResponse(
            incompleteResults: true, items: [], totalCount: 0));
    RepositoryListBloc bloc = RepositoryListBloc(repository: repository)
      ..add(LoadRepositories(searchPhase: "abcd"));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.loading),
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.success)
      ]),
    );
  });

  test('Search list  query', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getRepoList("abcd"))
        .thenAnswer((realInvocation) async => SearchRepositoriesResponse(
            incompleteResults: true,
            items: [
              Repository(
                  id: 1,
                  name: "name",
                  fullName: "full/name",
                  owner: RepositoryOwner(id: 1, avatarUrl: "", login: "login"))
            ],
            totalCount: 0));
    RepositoryListBloc bloc = RepositoryListBloc(repository: repository)
      ..add(LoadRepositories(searchPhase: "abcd"));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.loading),
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.success, response: [Repository(
            id: 1,
            name: "name",
            fullName: "full/name",
            owner: RepositoryOwner(id: 1, avatarUrl: "", login: "login"))])
      ]),
    );
  });

  test('Search list  error', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getRepoList("abcd"))
        .thenThrow(HttpStatus.networkConnectTimeoutError);
    RepositoryListBloc bloc = RepositoryListBloc(repository: repository)
      ..add(LoadRepositories(searchPhase: "abcd"));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.loading),
        const RepositoryListState()
            .copyWith(status: RepositoryListStatus.error, response: [])
      ]),
    );
  });
}

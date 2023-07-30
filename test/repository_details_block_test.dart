import 'package:flutter_test/flutter_test.dart';
import 'package:git_hub_repository_application/repository.dart';
import 'package:git_hub_repository_application/repository_details/repository_details_bloc.dart';
import 'package:git_hub_repository_application/rest_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_details_block_test.mocks.dart';

@GenerateMocks([RepositoryListRepository])
void main() {
  test('Empty lists test', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getRepositoryPulls(""))
        .thenAnswer((realInvocation) async => const []);
    when(repository.getRepositoryIssues(""))
        .thenAnswer((realInvocation) async => const []);
    RepositoryDetailsBloc bloc = RepositoryDetailsBloc(repository: repository)
      ..add(LoadRepositories());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryDetailsState()
            .copyWith(status: RepositoryDetailsStatus.loading),
        const RepositoryDetailsState()
            .copyWith(status: RepositoryDetailsStatus.success)
      ]),
    );
  });

  test('Some data lists test', () async {
    MockRepositoryListRepository repository = MockRepositoryListRepository();
    when(repository.getRepositoryPulls(""))
        .thenAnswer((realInvocation) async => [
              RepositoryPulls(
                  id: 0,
                  state: "open",
                  title: "title",
                  user: RepositoryOwner(id: 0, login: "login", avatarUrl: ""))
            ]);
    when(repository.getRepositoryIssues(""))
        .thenAnswer((realInvocation) async => [
              RepositoryIssues(
                  id: 0,
                  state: "open",
                  title: "title",
                  user: RepositoryOwner(id: 0, login: "login", avatarUrl: ""))
            ]);
    RepositoryDetailsBloc bloc = RepositoryDetailsBloc(repository: repository)
      ..add(LoadRepositories());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const RepositoryDetailsState()
            .copyWith(status: RepositoryDetailsStatus.loading),
        const RepositoryDetailsState()
            .copyWith(status: RepositoryDetailsStatus.success, pulls: [
          RepositoryPulls(
              id: 0,
              state: "open",
              title: "title",
              user: RepositoryOwner(id: 0, login: "login", avatarUrl: ""))
        ], issues: [
          RepositoryIssues(
              id: 0,
              state: "open",
              title: "title",
              user: RepositoryOwner(id: 0, login: "login", avatarUrl: ""))
        ])
      ]),
    );
  });
}

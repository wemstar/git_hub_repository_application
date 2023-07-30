import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repository_application/repository.dart';
import 'package:git_hub_repository_application/rest_client.dart';

class RepositoryListEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class LoadRepositories extends RepositoryListEvent {

  LoadRepositories({this.searchPhase = ""});
  final String searchPhase;

  @override
  List<Object> get props => [searchPhase];
}
class RefreshRepositories extends RepositoryListEvent {}

enum RepositoryListStatus {initial, loading, success, error }

extension RepositoryListStatusX on RepositoryListStatus {
  bool get isInitial => this == RepositoryListStatus.initial;
  bool get isSuccess => this == RepositoryListStatus.success;
  bool get isError => this == RepositoryListStatus.error;
  bool get isLoading => this == RepositoryListStatus.loading;
}

class RepositoryListState extends Equatable {

  const RepositoryListState({
    this.status = RepositoryListStatus.initial,
    this.searchPhrase = "",
    this.response = const []});


  final List<Repository> response;
  final RepositoryListStatus status;
  final String searchPhrase;

  @override
  List<Object?> get props => [response , status, searchPhrase];

  RepositoryListState copyWith({List<Repository>? response, String? searchPhrase, RepositoryListStatus? status}) {
    return RepositoryListState(
      response: response ?? this.response,
      searchPhrase: searchPhrase ?? this.searchPhrase,
      status: status ?? this.status,
    );
  }
}


class RepositoryListBloc extends Bloc<RepositoryListEvent, RepositoryListState> {

  RepositoryListBloc({required this.repository}) : super(const RepositoryListState()) {
    on<LoadRepositories>(_mapLoadRepositoriesToState);
    on<RefreshRepositories>(_mapRefreshRepositoriesToState);
  }

  final RepositoryListRepository repository;

  void _mapLoadRepositoriesToState(LoadRepositories event, Emitter<RepositoryListState> emit) async {
    await _loadData(event.searchPhase, emit);
  }

  void _mapRefreshRepositoriesToState(RefreshRepositories event, Emitter<RepositoryListState> emit) async {
    await _loadData(state.searchPhrase, emit);
  }

  Future<void> _loadData(String phrase, Emitter<RepositoryListState> emit) async {
    emit(state.copyWith(status: RepositoryListStatus.loading));
    try {
      List<Repository> repoList;
      if (phrase.isEmpty) {
        repoList = await repository.getDefaultRepoList();
      } else {
        repoList = (await repository.getRepoList(phrase)).items;
      }

      emit(state.copyWith(status: RepositoryListStatus.success, response: repoList));
    } catch (error) {
      emit(state.copyWith(status: RepositoryListStatus.error));
    }
  }



}


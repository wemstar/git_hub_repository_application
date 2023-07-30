import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repository_application/repository.dart';
import 'package:git_hub_repository_application/rest_client.dart';

class RepositoryDetailsEvent extends Equatable {

  @override
  List<Object> get props => [];

}

class LoadRepositories extends RepositoryDetailsEvent {

  LoadRepositories({this.fullName = ""});
  final String fullName;

  @override
  List<Object> get props => [fullName];
}
class LoadFinished extends RepositoryDetailsEvent {}

enum RepositoryDetailsStatus {initial, loading, success, error }

extension RepositoryDetailsStatusX on RepositoryDetailsStatus {
  bool get isInitial => this == RepositoryDetailsStatus.initial;
  bool get isSuccess => this == RepositoryDetailsStatus.success;
  bool get isError => this == RepositoryDetailsStatus.error;
  bool get isLoading => this == RepositoryDetailsStatus.loading;
}

class RepositoryDetailsState extends Equatable {

  const RepositoryDetailsState({
    this.status = RepositoryDetailsStatus.initial,
    this.pulls = const [],
    this.issues = const []});


  final List<RepositoryIssues> issues;
  final List<RepositoryPulls> pulls;
  final RepositoryDetailsStatus status;

  @override
  List<Object?> get props => [pulls , status, issues];

  RepositoryDetailsState copyWith({List<RepositoryIssues>? issues, List<RepositoryPulls>? pulls,  RepositoryDetailsStatus? status}) {
    return RepositoryDetailsState(
      pulls: pulls ?? this.pulls,
      issues: issues ?? this.issues,
      status: status ?? this.status,
    );
  }
}


class RepositoryDetailsBloc extends Bloc<RepositoryDetailsEvent, RepositoryDetailsState> {

  RepositoryDetailsBloc({required this.repository}) : super(const RepositoryDetailsState()) {
    on<LoadRepositories>(_mapLoadRepositoriesToState);
  }

  final RepositoryListRepository repository;

  void _mapLoadRepositoriesToState(LoadRepositories event, Emitter<RepositoryDetailsState> emit) async {
    emit(state.copyWith(status: RepositoryDetailsStatus.loading));
    try {
      final response = await Future.wait([
        repository.getRepositoryIssues(event.fullName),
        repository.getRepositoryPulls(event.fullName)
      ]);
      final List<RepositoryIssues> issueResponse = response.first.map((e) => e as RepositoryIssues).toList();
      final List<RepositoryPulls> pullsResponse = response.last.map((e) => e as RepositoryPulls).toList();
      emit(state.copyWith(status: RepositoryDetailsStatus.success, issues: issueResponse, pulls: pullsResponse));
    } catch (error) {
      emit(state.copyWith(status: RepositoryDetailsStatus.error));
    }
  }



}

class RepositoryDetailsRepository {
  const RepositoryDetailsRepository({
    required this.restClient});

  final RestClient restClient;


}
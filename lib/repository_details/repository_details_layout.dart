import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repository_application/repository.dart';
import 'package:git_hub_repository_application/rest_client.dart';

import 'repository_details_bloc.dart';

class RepositoryDetailsPage extends StatelessWidget {
  const RepositoryDetailsPage({Key? key, required this.repository})
      : super(key: key);

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              // TRY THIS: Try changing the color here to a specific color (to
              // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
              // change color while the other colors stay the same.
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(repository.name),
            bottom: const TabBar(tabs: [
              Tab(text: "Issue"),
              Tab(text: "Pulls",)
            ],) ,),
          body: BlocProvider(
              create: (context) => RepositoryDetailsBloc(
                  repository: context.read<RepositoryListRepository>())
                ..add(LoadRepositories(fullName: repository.fullName)),
              child:
                  const RepositoryDetailsLayout() // This trailing comma makes auto-formatting nicer for build methods.
              )),
    );
  }
}

class RepositoryDetailsLayout extends StatelessWidget {
  const RepositoryDetailsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepositoryDetailsBloc, RepositoryDetailsState>(
        builder: (context, state) {
      if (state.status.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        );
      } else if (state.status.isSuccess) {
        return TabBarView(children: [
          _buildIssuesList(context, state.issues),
          _buildPullsList(context, state.pulls)
        ]);
      }

      return const Text("Initial");
    });
  }

  Widget _buildIssuesList(BuildContext context, List<RepositoryIssues> items) {
    return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            RepositoryIssues issue = items[index];
            return Card(
              child: ListTile(
                leading: Image.network(issue.user.avatarUrl),
                title: Text(issue.title),
                  trailing: issue.state == "open" ?
                  const Icon(Icons.add_box_rounded, color: Colors.green) : const Icon(Icons.indeterminate_check_box_rounded, color: Colors.red,)
              ),
            );
          },
        );
  }

  Widget _buildPullsList(BuildContext context, List<RepositoryPulls> items) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          RepositoryPulls pull = items[index];
          return Card(
            child: ListTile(
              leading: Image.network(pull.user.avatarUrl, ),
              title: Text(pull.title),
              trailing: pull.state == "open" ?
              const Icon(Icons.add_box_rounded, color: Colors.green) : const Icon(Icons.indeterminate_check_box_rounded, color: Colors.red,),
            ),
          );
        },
      );
  }
}

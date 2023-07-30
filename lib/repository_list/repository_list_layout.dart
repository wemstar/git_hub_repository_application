import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_hub_repository_application/repository.dart';
import 'package:git_hub_repository_application/repository_details/repository_details_layout.dart';
import 'package:git_hub_repository_application/repository_list/repository_list_bloc.dart';
import 'package:git_hub_repository_application/rest_client.dart';


class RepositoryListPage extends StatelessWidget {


  const RepositoryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RepositoryListBloc(repository: context.read<RepositoryListRepository>())..add(LoadRepositories(searchPhase: "")),
      child: Scaffold(
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Builder(
              builder: (context) {
                return TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onChanged: (searchPhase) => context.read<RepositoryListBloc>().add(LoadRepositories(searchPhase: searchPhase)),
                );
              }
            ),
          ),
          body: const RepositoryListLayout() // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class RepositoryListLayout extends StatelessWidget {
  const RepositoryListLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepositoryListBloc, RepositoryListState>(builder: (context, state) {
      if (state.status.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        );
      } else if (state.status.isSuccess) {
        return _buildRepositoryList(context, state.response);
      } else if (state.status.isError) {
        return const Text("ERROR");
      }

      return const Text("Initial");
    });
  }

  Widget _buildRepositoryList(BuildContext context, List<Repository> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<RepositoryListBloc>().add(RefreshRepositories());
      },
      child: ListView.builder(
        itemCount: items.length,
        prototypeItem: ListTile(
          title: Text(items.first.name),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            leading: Image.network(items[index].owner.avatarUrl),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RepositoryDetailsPage(repository: items[index])),
            ),
          );
        },
      ),
    );
  }

}


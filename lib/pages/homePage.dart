import 'package:bloc_crud/blocs/user_bloc.dart';
import 'package:bloc_crud/pages/addData.dart';
import 'package:bloc_crud/pages/updateData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    userBloc.add(FetchUsersEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent.withOpacity(0.3),
      ),
      body: StreamBuilder<UserState>(
        stream: userBloc.stream,
        builder: (context, snapshot) {
          // Handle no data yet
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Users found!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final state = snapshot.data;

          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserOperationInProgressState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoadedState) {
            final users = state.users;

            if (users.isEmpty) {
              return const Center(
                child: Text(
                  'No Users found!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            user.contactNumber.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateData(userUpdate: user),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showCustomDialog(context, user.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is UserErrorState) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text(
              'No Users Found!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDataPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showCustomDialog(BuildContext context, String id) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                CupertinoIcons.question_circle,
                size: 100,
              ),
              const SizedBox(
                height: 12,
              ),
              // Main container for dialog content
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Are You Sure?",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Do you really want to delete this record?"),
              const SizedBox(
                height: 2,
              ),
              const Text("This procress can't be undone."),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        )),
                    onPressed: () {
                      userBloc.add(DeleteUserEvent(id));
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}

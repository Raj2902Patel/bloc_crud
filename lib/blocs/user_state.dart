part of 'user_bloc.dart';

@immutable
abstract class UserState {}

final class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserOperationInProgressState extends UserState {}

class UsersLoadedState extends UserState {
  final List<User> users;
  UsersLoadedState(this.users);
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
}

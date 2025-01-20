part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class FetchUsersEvent extends UserEvent {}

class AddUsersEvent extends UserEvent {
  final User user;
  AddUsersEvent(this.user);
}

class UpdateUserEvent extends UserEvent {
  final User user;
  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends UserEvent {
  final String userId;
  DeleteUserEvent(this.userId);
}

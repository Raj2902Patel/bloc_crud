import 'package:bloc/bloc.dart';
import 'package:bloc_crud/models/userModel.dart';
import 'package:bloc_crud/repositories/userRepository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitialState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<AddUsersEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onFetchUsers(
      FetchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final users = await userRepository.fetchUsers();
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onAddUser(AddUsersEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgressState());
    try {
      await userRepository.addUser(event.user);
      add(FetchUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgressState());
    try {
      await userRepository.updateUser(event.user);
      add(FetchUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgressState());
    try {
      await userRepository.deleteUser(event.userId);
      add(FetchUsersEvent());
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}

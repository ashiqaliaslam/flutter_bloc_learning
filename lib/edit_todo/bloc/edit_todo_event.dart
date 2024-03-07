part of 'edit_todo_bloc.dart';

/// blueprint
sealed class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];
}

/// change title
final class EditTodoTitleChanged extends EditTodoEvent {
  final String title;

  const EditTodoTitleChanged(this.title);

  @override
  List<Object> get props => [title];
}

/// change description
final class EditTodoDescriptionChanged extends EditTodoEvent {
  final String description;

  const EditTodoDescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
}

/// submit after editing
final class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}

abstract class DocStates {}

class DocInitialState extends DocStates {}

class DocumentsSuccessState extends DocStates {}

class LoadingDocumentsState extends DocStates {}

class DocErrorState extends DocStates {
  final String error;

  DocErrorState(this.error);
}

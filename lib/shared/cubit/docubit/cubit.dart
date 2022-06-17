import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurances/model/document_model.dart';
import 'package:insurances/shared/cubit/docubit/states.dart';

class DocCubit extends Cubit<DocStates>{
  DocCubit() : super(DocInitialState());

  List<DocumentModel> clientDocs = [];
  static DocCubit get(context) => BlocProvider.of(context);
  void getClientDocuments({
  required clientCIN,
}) async {
    emit(LoadingDocumentsState());
    await FirebaseFirestore.instance.collection('documents').get().then((value) =>{
      value.docs.forEach((element) {
        if(element.get('clientCIN') == clientCIN){
          clientDocs.add(DocumentModel.fromJson(element.data()));
        }
      }),
    });
    emit(DocumentsSuccessState());
  }

}
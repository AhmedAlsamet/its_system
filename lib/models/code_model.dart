// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:its_system/models/general_model.dart';

class CodeModel {
  // for all codings in system
  int? codeId;
  GeneralModel? codeName;
  int? supperId;
  CodeModel({this.codeId,this.codeName,this.supperId});

  CodeModel copyWith({
    int? codeId,
    GeneralModel? codeName,
    int? supperId,
  }) {
    return CodeModel(
      codeId: codeId ?? this.codeId,
      codeName: GeneralModel().copyWith(general: this.codeName),
      supperId: supperId ?? this.supperId,
    );
  }
}

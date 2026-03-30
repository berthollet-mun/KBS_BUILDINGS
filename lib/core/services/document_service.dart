import 'dart:io';
import 'package:get/get.dart';
import '../../data/models/document_model.dart';
import 'api_service.dart';

class DocumentService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  /// GET /api/documents
  Future<ApiResult> getDocuments({
    String? entiteType,
    int? entiteId,
  }) async {
    final params = <String, String>{};
    if (entiteType != null) params['entite_type'] = entiteType;
    if (entiteId != null) params['entite_id'] = entiteId.toString();

    return await _api.get('/documents', queryParams: params);
  }

  /// POST /api/documents/upload
  Future<ApiResult> uploadDocument({
    required File fichier,
    required String typeDocument,
    required String entiteType,
    required int entiteId,
    String? subfolder,
  }) async {
    final fields = <String, String>{
      'type_document': typeDocument,
      'entite_type': entiteType,
      'entite_id': entiteId.toString(),
    };
    if (subfolder != null) fields['subfolder'] = subfolder;

    return await _api.uploadFile(
      '/documents/upload',
      file: fichier,
      fields: fields,
    );
  }

  /// Parse les documents
  List<DocumentModel> parseDocuments(ApiResult result) {
    if (!result.success || result.responseData == null) return [];
    if (result.responseData is List) {
      return (result.responseData as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList();
    }
    return [];
  }

  /// Parse un document
  DocumentModel? parseDocument(ApiResult result) {
    if (!result.success || result.responseData == null) return null;
    return DocumentModel.fromJson(result.responseData);
  }
}
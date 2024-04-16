import 'package:dio/dio.dart';
import 'package:ecommerceassim/shared/constants/app_text_constants.dart';
import 'package:ecommerceassim/shared/core/models/banca_model.dart';
import 'package:ecommerceassim/shared/core/user_storage.dart';

class BancaRepository {
  final Dio _dio;

  BancaRepository(this._dio);

  Future<List<BancaModel>> getBancas(int feiraId) async {
    final userToken = await UserStorage().getUserToken();

    try {
      final response = await _dio.get(
        '$kBaseURL/feiras/$feiraId/bancas',
        options: Options(
          headers: {"Authorization": "Bearer $userToken"},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> bancasJson = response.data['bancas'] ?? [];
        return bancasJson
            .map((bancaJson) => BancaModel.fromJson(bancaJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load bancas with status code: ${response.statusCode}.');
      }
    } on DioError catch (dioError) {
      // Handle Dio-specific errors here
      throw Exception('DioError caught: ${dioError.message}');
    } catch (error) {
      // Handle general errors here
      throw Exception('An unexpected error occurred: $error');
    }
  }
}

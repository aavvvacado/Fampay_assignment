import 'package:dio/dio.dart';
import '../models/api_response.dart';

class CardsRepository {
  final Dio dio;
  CardsRepository(this.dio);

  Future<ApiResponse> fetchCards() async {
    final response = await dio.get("home_section/?slugs=famx-paypage");
    return ApiResponse.fromJson(response.data);
  }
}

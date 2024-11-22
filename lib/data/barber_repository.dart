import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/barber.dart';

class BarberRepository {
  Future<Map<String, dynamic>> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/v2.json');
      final data = json.decode(response);
      return data;
    } catch (e) {
      throw Exception('Error loading JSON data: $e');
    }
  }

  Future<List<BarberInfo>> getNearestBarbershops() async {
    final data = await loadJsonData();
    return (data['nearest_barbershop'] as List)
        .map((item) => BarberInfo.fromJson(item))
        .toList();
  }

  Future<List<BarberInfo>> getMostRecommended() async {
    final data = await loadJsonData();
    return (data['most_recommended'] as List)
        .map((item) => BarberInfo.fromJson(item))
        .toList();
  }

  Future<List<dynamic>> getCarouselItems() async {
    final data = await loadJsonData();
    return data['list'] as List;
  }
}

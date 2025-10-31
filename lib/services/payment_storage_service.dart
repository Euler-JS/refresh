import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/model.dart';

class PaymentStorageService {
  static const String _paymentsKey = 'payments';
  static PaymentStorageService? _instance;

  PaymentStorageService._();

  static PaymentStorageService get instance {
    _instance ??= PaymentStorageService._();
    return _instance!;
  }

  Future<List<PaymentModel>> loadPayments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = prefs.getStringList(_paymentsKey) ?? [];
      return paymentsJson.map((json) => PaymentModel.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> savePayments(List<PaymentModel> payments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = payments.map((payment) => jsonEncode(payment.toJson())).toList();
      await prefs.setStringList(_paymentsKey, paymentsJson);
    } catch (e) {
      throw Exception('Erro ao salvar pagamentos: $e');
    }
  }

  Future<void> addPayment(PaymentModel payment) async {
    final payments = await loadPayments();
    payments.add(payment);
    await savePayments(payments);
  }

  Future<void> updatePayment(String id, PaymentModel updatedPayment) async {
    final payments = await loadPayments();
    final index = payments.indexWhere((p) => p.id == id);
    if (index != -1) {
      payments[index] = updatedPayment;
      await savePayments(payments);
    }
  }

  Future<void> deletePayment(String id) async {
    final payments = await loadPayments();
    payments.removeWhere((p) => p.id == id);
    await savePayments(payments);
  }

  Future<PaymentModel?> getPaymentById(String id) async {
    final payments = await loadPayments();
    try {
      return payments.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
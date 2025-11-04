// lib/screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'subscription_screen.dart';

class PaymentScreen extends StatefulWidget {
  final PlanOption plan;
  final VoidCallback onPaymentSuccess;

  const PaymentScreen({
    Key? key,
    required this.plan,
    required this.onPaymentSuccess,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    // Remove todos os espaços e limita a 16 dígitos
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // Adiciona espaços a cada 4 dígitos
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    return formatted;
  }

  String _formatExpiryDate(String value) {
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    if (digitsOnly.length >= 2) {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    }

    return digitsOnly;
  }

  bool _isValidCardNumber(String cardNumber) {
    // Remove espaços
    final digitsOnly = cardNumber.replaceAll(' ', '');

    // Verifica se tem 16 dígitos
    if (digitsOnly.length != 16) return false;

    // Algoritmo de Luhn para validação
    int sum = 0;
    bool alternate = false;

    for (int i = digitsOnly.length - 1; i >= 0; i--) {
      int digit = int.parse(digitsOnly[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool _isValidExpiryDate(String expiry) {
    if (expiry.length != 5 || !expiry.contains('/')) return false;

    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}');

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiryDate = DateTime(year, month);

    return expiryDate.isAfter(now);
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      // Simular processamento de pagamento com possibilidade de falha
      await Future.delayed(const Duration(seconds: 2));

      // Simular chance de falha (10% de chance)
      final random = DateTime.now().millisecondsSinceEpoch % 100;
      if (random < 10) {
        throw Exception('Pagamento rejeitado pelo banco emissor');
      }

      if (mounted) {
        // Pagamento bem-sucedido
        widget.onPaymentSuccess();
        Navigator.of(context).pop(true);

        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pagamento processado com sucesso!'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);

        // Mostrar erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro no pagamento: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A4C93),
              Color(0xFF8E44AD),
              Color(0xFFA569BD),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Pagamento",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 40),

                // Resumo do plano
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plan.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.plan.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total a pagar:",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "MZN ${widget.plan.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Formulário de pagamento
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dados do Cartão",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A4C93),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nome no cartão
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Nome no cartão",
                            hintText: "João Silva",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nome é obrigatório";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Número do cartão
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: const InputDecoration(
                            labelText: "Número do cartão",
                            hintText: "1234 5678 9012 3456",
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(19), // 16 dígitos + 3 espaços
                          ],
                          onChanged: (value) {
                            final formatted = _formatCardNumber(value);
                            if (formatted != value) {
                              _cardNumberController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: formatted.length),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Número do cartão é obrigatório";
                            }
                            final digitsOnly = value.replaceAll(' ', '');
                            if (digitsOnly.length != 16) {
                              return "Número do cartão deve ter 16 dígitos";
                            }
                            if (!_isValidCardNumber(value)) {
                              return "Número do cartão inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Data de validade e CVV
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryController,
                                decoration: const InputDecoration(
                                  labelText: "Validade",
                                  hintText: "MM/AA",
                                  prefixIcon: Icon(Icons.date_range),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                onChanged: (value) {
                                  final formatted = _formatExpiryDate(value);
                                  if (formatted != value) {
                                    _expiryController.value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(offset: formatted.length),
                                    );
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Validade é obrigatória";
                                  }
                                  if (value.length != 5) {
                                    return "Formato MM/AA";
                                  }
                                  if (!_isValidExpiryDate(value)) {
                                    return "Data inválida ou expirada";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                decoration: const InputDecoration(
                                  labelText: "CVV",
                                  hintText: "123",
                                  prefixIcon: Icon(Icons.security),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "CVV é obrigatório";
                                  }
                                  if (value.length < 3) {
                                    return "CVV deve ter 3-4 dígitos";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Botão de pagamento
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4ECDC4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Pagar MZN ${widget.plan.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Pagamento seguro processado por nossa plataforma",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar e voltar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
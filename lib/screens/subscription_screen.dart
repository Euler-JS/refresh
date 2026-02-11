// lib/screens/subscription_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// URL base da API (mesma do auth_service.dart)
// Para desenvolvimento local, use: 'http://10.0.2.2:3000/api' (Android Emulator)
// Para ngrok, use: 'https://SEU_NGROK_URL.ngrok-free.app/api'
// const String _apiBaseUrl = 'https://82505d83b1a7.ngrok-free.app/api';
// const String _apiBaseUrl = 'http://localhost:3000/api';
const String _apiBaseUrl = 'https://refresh-api.manna.software/api';

class SubscriptionModel {
  final String id;
  final String plan;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int daysRemaining;
  final bool isValid;

  SubscriptionModel({
    required this.id,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.daysRemaining,
    required this.isValid,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['subscription']['_id'],
      plan: json['subscription']['plan'],
      startDate: DateTime.parse(json['subscription']['startDate']),
      endDate: DateTime.parse(json['subscription']['endDate']),
      status: json['subscription']['status'],
      daysRemaining: json['daysRemaining'],
      isValid: json['isValid'],
    );
  }
}

class PlanOption {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> features;
  final String type;

  PlanOption({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.features,
    required this.type,
  });

  factory PlanOption.fromJson(Map<String, dynamic> json) {
    return PlanOption(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<String>.from(json['features']),
      type: json['type'],
    );
  }
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = true;
  bool _isCreatingSubscription = false;
  bool _isLoadingPlans = true;
  SubscriptionModel? _subscription;
  String? _error;
  int _selectedPlanIndex = 0;

  // Planos disponíveis (serão carregados da API)
  List<PlanOption> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
    _loadSubscription();
  }

  // Carregar planos disponíveis da API
  Future<void> _loadPlans() async {
    setState(() => _isLoadingPlans = true);

    try {
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/plans'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success']) {
          List<dynamic> plansJson = data['plans'];
          
          setState(() {
            _plans = plansJson.map((json) => PlanOption.fromJson(json)).toList();
            _isLoadingPlans = false;
          });
        } else {
          setState(() {
            _error = "Erro ao carregar planos";
            _isLoadingPlans = false;
          });
        }
      } else {
        setState(() {
          _error = "Erro ao carregar planos disponíveis";
          _isLoadingPlans = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erro de conexão ao carregar planos. Verifique sua internet.";
        _isLoadingPlans = false;
      });
    }
  }

  // Carregar informações de subscrição
  Future<void> _loadSubscription() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Usar a mesma chave do AuthService

      if (token == null) {
        setState(() {
          _error = "Erro de autenticação. Por favor, faça login novamente.";
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _subscription = SubscriptionModel.fromJson(data);
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Não tem subscrição ativa, é normal
        setState(() => _isLoading = false);
      } else {
        final data = json.decode(response.body);
        setState(() {
          _error = data['message'] ?? "Erro ao carregar subscrição";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erro de conexão. Verifique sua internet.";
        _isLoading = false;
      });
    }
  }

  // Criar nova subscrição
  Future<void> _createSubscription(String planType) async {
    // Primeiro, navegar para a tela de pagamento
   _processSubscription(planType);
  }

  // Processar a assinatura após pagamento bem-sucedido
  Future<void> _processSubscription(String planType) async {
    setState(() => _isCreatingSubscription = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Usar a mesma chave do AuthService

      if (token == null) {
        setState(() {
          _error = "Erro de autenticação. Por favor, faça login novamente.";
          _isCreatingSubscription = false;
        });
        return;
      }

      print('📤 Enviando requisição de subscrição...');
      print('🔑 Token: $token');
      print('📋 Plano: $planType');

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'plan': planType,
        }),
      );

      print('📥 Resposta recebida!');
      print('🔢 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ Subscrição criada com sucesso!');
        print('📦 RESPOSTA COMPLETA DO SERVIDOR:');
        print('   📄 Subscription: ${json.encode(data['subscription'])}');
        print('   💳 Payment: ${json.encode(data['payment'])}');
        print('   📅 Days Remaining: ${data['daysRemaining']}');
        print('   ✔️  Is Valid: ${data['isValid']}');
        
        // Extrair informações de pagamento e usuário
        final paymentReference = data['payment']?['reference'] ?? 'N/A';
        final amount = data['payment']?['amount'] ?? 0;
        final planName = data['subscription']?['plan'] ?? planType;
        final userId = data['subscription']?['user'] ?? prefs.getString('user_id') ?? 'N/A';
        final userName = data['user']?['username'] ?? 'N/A';
        
        print('📝 Payment Reference: $paymentReference');
        print('💰 Amount: $amount MZN');
        print('📋 Plan: $planName');
        print('👤 User ID: $userId');
        print('👤 User Name: $userName');
        
        setState(() => _isCreatingSubscription = false);
        
        // Criar mensagem para WhatsApp com detalhes do pagamento
        final String whatsappMessage = '''
Olá! Gostaria de confirmar o pagamento da minha assinatura:

👤 *Nome:* $userName
🆔 *ID:* $userId
📋 *Plano:* $planName
💰 *Valor:* ${amount.toStringAsFixed(2)} MZN
🔖 *Referência:* $paymentReference
📅 *Data:* ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

Por favor, confirme o pagamento para ativar minha assinatura.
        '''.trim();
        
        // Abrir WhatsApp com a mensagem
        // Número do WhatsApp da empresa (adicione o número correto aqui)
        final String phoneNumber = '258846151124'; // Trocar pelo número real
        final String whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(whatsappMessage)}';
        
        print('📱 Abrindo WhatsApp...');
        print('🔗 URL: $whatsappUrl');
        
        try {
          final Uri uri = Uri.parse(whatsappUrl);
          final bool launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          
          if (launched) {
            print('✅ WhatsApp aberto com sucesso!');
            _showSuccessMessage("Complete o pagamento via WhatsApp!");
            
            // Recarregar a subscrição (que estará com status pendente)
            await _loadSubscription();
          } else {
            print('❌ Não foi possível abrir o WhatsApp');
            _showSuccessMessage("Erro ao abrir WhatsApp. Referência: $paymentReference");
          }
        } catch (e) {
          print('❌ Erro ao abrir WhatsApp: $e');
          _showSuccessMessage("Erro ao abrir WhatsApp. Referência: $paymentReference");
          
          // Mesmo com erro, recarregar a subscrição
          await _loadSubscription();
        }
      } else {
        final data = json.decode(response.body);
        print('❌ Erro ao criar subscrição');
        print('⚠️ Mensagem de erro: ${data['message']}');
        
        setState(() {
          _error = data['message'] ?? "Erro ao criar subscrição";
          _isCreatingSubscription = false;
        });
      }
    } catch (e) {
      print('💥 Erro na requisição: $e');
      setState(() {
        _error = "Erro de conexão. Verifique sua internet.";
        _isCreatingSubscription = false;
      });
    }
  }  // Verificar status da subscrição e abrir pagamento se pendente
  Future<void> _renewSubscription() async {
    setState(() => _isCreatingSubscription = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Usar a mesma chave do AuthService

      if (token == null) {
        setState(() {
          _error = "Erro de autenticação. Por favor, faça login novamente.";
          _isCreatingSubscription = false;
        });
        return;
      }

      print('📤 Buscando status atualizado da subscrição na API...');

      // Primeiro, buscar o status atualizado da subscrição na API
      final subscriptionResponse = await http.get(
        Uri.parse('$_apiBaseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Resposta da subscrição recebida!');
      print('🔢 Status Code: ${subscriptionResponse.statusCode}');
      print('📄 Response Body: ${subscriptionResponse.body}');

      if (subscriptionResponse.statusCode == 200) {
        final subscriptionData = json.decode(subscriptionResponse.body);
        final currentStatus = subscriptionData['subscription']['status'];
        final subscriptionId = subscriptionData['subscription']['_id'];
        
        print('🔍 Status atual da API: $currentStatus');

        // Verificar se a subscrição está pendente (qualquer variação de pending)
        if (currentStatus == 'pendente' || 
            currentStatus == 'pending' || 
            currentStatus == 'pending_payment') {
          print('⏳ Subscrição com pagamento pendente, abrindo WhatsApp...');
          
          // Extrair informações de pagamento e usuário diretamente da resposta
          final paymentReference = subscriptionData['payment']?['reference'] ?? 'N/A';
          final amount = subscriptionData['payment']?['amount'] ?? 0;
          final planName = subscriptionData['subscription']?['plan'] ?? 'N/A';
          final userId = subscriptionData['subscription']?['user'] ?? prefs.getString('user_id') ?? 'N/A';
          final userName = subscriptionData['user']?['username'] ?? 'N/A';
          
          print('📝 Payment Reference: $paymentReference');
          print('💰 Amount: $amount MZN');
          print('📋 Plan: $planName');
          print('👤 User ID: $userId');
          print('👤 User Name: $userName');
          print('📦 Dados completos do pagamento: ${json.encode(subscriptionData['payment'])}');

          setState(() => _isCreatingSubscription = false);

          // Criar mensagem para WhatsApp com detalhes do pagamento
          final String whatsappMessage = '''
Olá! Gostaria de confirmar o pagamento da minha assinatura:

👤 *Nome:* $userName
🆔 *ID:* $userId
📋 *Plano:* $planName
💰 *Valor:* ${amount.toStringAsFixed(2)} MZN
🔖 *Referência:* $paymentReference
📅 *Data:* ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

Por favor, confirme o pagamento para ativar minha assinatura.
          '''.trim();
          
          // Abrir WhatsApp com a mensagem
          final String phoneNumber = '258849876543'; // Trocar pelo número real
          final String whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(whatsappMessage)}';
          
          print('📱 Abrindo WhatsApp...');
          
          try {
            final Uri uri = Uri.parse(whatsappUrl);
            final bool launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
            
            if (launched) {
              print('✅ WhatsApp aberto com sucesso!');
              _showSuccessMessage("Complete o pagamento via WhatsApp!");
              await _loadSubscription();
            } else {
              print('❌ Não foi possível abrir o WhatsApp');
              _showSuccessMessage("Erro ao abrir WhatsApp. Referência: $paymentReference");
            }
          } catch (e) {
            print('❌ Erro ao abrir WhatsApp: $e');
            _showSuccessMessage("Erro ao abrir WhatsApp. Referência: $paymentReference");
            await _loadSubscription();
          }
        } else {
          // Subscrição não está pendente
          setState(() => _isCreatingSubscription = false);
          _showSuccessMessage("Subscrição já está $currentStatus");
        }
      } else if (subscriptionResponse.statusCode == 404) {
        setState(() {
          _error = "Nenhuma subscrição encontrada";
          _isCreatingSubscription = false;
        });
      } else {
        final data = json.decode(subscriptionResponse.body);
        setState(() {
          _error = data['message'] ?? "Erro ao verificar subscrição";
          _isCreatingSubscription = false;
        });
      }
    } catch (e) {
      print('💥 Erro na requisição: $e');
      setState(() {
        _error = "Erro de conexão. Verifique sua internet.";
        _isCreatingSubscription = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
          child: _isLoading || _isLoadingPlans
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : _error != null
              ? _buildErrorView()
              : _subscription != null
                ? _buildActiveSubscriptionView()
                : _buildPlansView(),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Ocorreu um erro',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Erro desconhecido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _loadSubscription(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6A4C93),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Tentar Novamente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSubscriptionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com botão de voltar
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
                "Minha Subscrição",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 40), // Equilibrar o layout
            ],
          ),
          const SizedBox(height: 40),

          // Ícone e título
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Plano Ativo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subscription!.plan == 'monthly' ? 'Plano Mensal' : 'Plano Anual',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Detalhes da subscrição
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  "Data de Início",
                  _formatDate(_subscription!.startDate),
                  Icons.calendar_today,
                ),
                const Divider(height: 32),
                _buildInfoRow(
                  "Data de Término",
                  _formatDate(_subscription!.endDate),
                  Icons.event,
                ),
                const Divider(height: 32),
                _buildInfoRow(
                  "Dias Restantes",
                  "${_subscription!.daysRemaining} dias",
                  Icons.timelapse,
                ),
                const Divider(height: 32),
                _buildInfoRow(
                  "Status",
                  _subscription!.isValid ? "Ativo" : "Expirado",
                  _subscription!.isValid ? Icons.check_circle : Icons.cancel,
                  valueColor: _subscription!.isValid ? const Color(0xFF4ECDC4) : Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Botão de renovar
          if (!_subscription!.isValid || _subscription!.daysRemaining < 7)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isCreatingSubscription ? null : _renewSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: _isCreatingSubscription
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Renovar Subscrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlansView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com botão de voltar
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
                "Planos de Subscrição",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 40), // Equilibrar o layout
            ],
          ),
          const SizedBox(height: 40),

          // Título e subtítulo
          const Text(
            "Escolha seu plano",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Selecione o plano mais adequado para suas necessidades",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 40),

          // Cards de planos
          if (_plans.isEmpty)
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 60,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nenhum plano disponível no momento",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPlans,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6A4C93),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
          else
            for (int i = 0; i < _plans.length; i++)
              _buildPlanCard(_plans[i], i),

          const SizedBox(height: 40),

          // Botão de assinar (só mostrar se houver planos)
          if (_plans.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isCreatingSubscription
                    ? null
                    : () => _createSubscription(_plans[_selectedPlanIndex].type),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: _isCreatingSubscription
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                      'Assinar Agora',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),

          const SizedBox(height: 16),
          // Termos e condições (só mostrar se houver planos)
          if (_plans.isNotEmpty)
            Center(
              child: Text(
                "Ao assinar, você concorda com nossos Termos de Serviço",
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanOption plan, int index) {
    final isSelected = index == _selectedPlanIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF4ECDC4), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6A4C93),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF4ECDC4)
                        : Colors.grey.withOpacity(0.2),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4ECDC4)
                          : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "MZN ${plan.price.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A4C93),
              ),
            ),
            Text(
              plan.type == "monthly" ? "por mês" : "por ano",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Column(
              children: plan.features.map((feature) => _buildFeatureItem(feature)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: const Color(0xFF4ECDC4),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF6A4C93),
          size: 24,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
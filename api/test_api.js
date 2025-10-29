// Teste simples da API
// Execute com: node test_api.js

const axios = require('axios');

const BASE_URL = 'http://localhost:3000';

async function testAPI() {
  console.log('🧪 Testando API Refresh...\n');

  try {
    // Testar endpoint público (planos)
    console.log('📋 Testando endpoint de planos...');
    const plansResponse = await axios.get(`${BASE_URL}/plans`);
    console.log('✅ Planos obtidos:', plansResponse.data.length, 'planos\n');

    // Testar registro (opcional - descomente se quiser testar)
    /*
    console.log('👤 Testando registro...');
    const registerResponse = await axios.post(`${BASE_URL}/auth/register`, {
      email: `test${Date.now()}@example.com`,
      password: 'test123456',
      full_name: 'Usuário Teste'
    });
    console.log('✅ Usuário registrado:', registerResponse.data.user.email);
    */

    console.log('🎉 API está funcionando corretamente!');
    console.log('📱 Pronto para integração com o app mobile!');

  } catch (error) {
    console.error('❌ Erro no teste:', error.response?.data || error.message);
  }
}

// Executar teste apenas se chamado diretamente
if (require.main === module) {
  testAPI();
}

module.exports = { testAPI };
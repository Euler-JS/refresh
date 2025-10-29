require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { createClient } = require('@supabase/supabase-js');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

// Middleware para verificar autenticação
const authenticateUser = async (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ error: 'Token de autenticação necessário' });
  }

  try {
    const { data: { user }, error } = await supabase.auth.getUser(token);

    if (error || !user) {
      return res.status(401).json({ error: 'Token inválido' });
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Erro na autenticação' });
  }
};

// ==========================================
// AUTENTICAÇÃO
// ==========================================

// Registro de usuário
app.post('/auth/register', async (req, res) => {
  try {
    const { email, password, full_name, phone } = req.body;

    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name,
          phone
        }
      }
    });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      user: data.user,
      session: data.session
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Login
app.post('/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      user: data.user,
      session: data.session
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Logout
app.post('/auth/logout', authenticateUser, async (req, res) => {
  try {
    const { error } = await supabase.auth.signOut();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Logout realizado com sucesso' });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Verificar sessão
app.get('/auth/me', authenticateUser, async (req, res) => {
  try {
    const { data: profile, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', req.user.id)
      .single();

    if (error && error.code !== 'PGRST116') {
      return res.status(400).json({ error: error.message });
    }

    res.json({
      user: req.user,
      profile: profile || null
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// PERFIS
// ==========================================

// Atualizar perfil
app.put('/profile', authenticateUser, async (req, res) => {
  try {
    const { full_name, phone, address } = req.body;

    const { data, error } = await supabase
      .from('profiles')
      .upsert({
        id: req.user.id,
        full_name,
        phone,
        address
      })
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// CLIENTES
// ==========================================

// Listar clientes do usuário
app.get('/clients', authenticateUser, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('clients')
      .select('*')
      .eq('user_id', req.user.id)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Criar cliente
app.post('/clients', authenticateUser, async (req, res) => {
  try {
    const { name, email, phone, address, notes } = req.body;

    const { data, error } = await supabase
      .from('clients')
      .insert({
        user_id: req.user.id,
        name,
        email,
        phone,
        address,
        notes
      })
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Atualizar cliente
app.put('/clients/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, phone, address, notes } = req.body;

    const { data, error } = await supabase
      .from('clients')
      .update({
        name,
        email,
        phone,
        address,
        notes
      })
      .eq('id', id)
      .eq('user_id', req.user.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Deletar cliente
app.delete('/clients/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('clients')
      .delete()
      .eq('id', id)
      .eq('user_id', req.user.id);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Cliente deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// SERVIÇOS
// ==========================================

// Listar serviços do usuário
app.get('/services', authenticateUser, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .eq('user_id', req.user.id)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Criar serviço
app.post('/services', authenticateUser, async (req, res) => {
  try {
    const { name, description, price, duration_minutes, category } = req.body;

    const { data, error } = await supabase
      .from('services')
      .insert({
        user_id: req.user.id,
        name,
        description,
        price,
        duration_minutes,
        category
      })
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Atualizar serviço
app.put('/services/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, price, duration_minutes, category } = req.body;

    const { data, error } = await supabase
      .from('services')
      .update({
        name,
        description,
        price,
        duration_minutes,
        category
      })
      .eq('id', id)
      .eq('user_id', req.user.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Deletar serviço
app.delete('/services/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', id)
      .eq('user_id', req.user.id);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Serviço deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// AGENDAMENTOS
// ==========================================

// Listar agendamentos do usuário
app.get('/schedules', authenticateUser, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('schedules')
      .select(`
        *,
        clients (id, name, phone),
        services (id, name, price, duration_minutes)
      `)
      .eq('user_id', req.user.id)
      .order('scheduled_at', { ascending: true });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Criar agendamento
app.post('/schedules', authenticateUser, async (req, res) => {
  try {
    const { client_id, service_id, scheduled_at, notes } = req.body;

    const { data, error } = await supabase
      .from('schedules')
      .insert({
        user_id: req.user.id,
        client_id,
        service_id,
        scheduled_at,
        notes
      })
      .select(`
        *,
        clients (id, name, phone),
        services (id, name, price, duration_minutes)
      `)
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Atualizar agendamento
app.put('/schedules/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const { client_id, service_id, scheduled_at, status, notes } = req.body;

    const { data, error } = await supabase
      .from('schedules')
      .update({
        client_id,
        service_id,
        scheduled_at,
        status,
        notes
      })
      .eq('id', id)
      .eq('user_id', req.user.id)
      .select(`
        *,
        clients (id, name, phone),
        services (id, name, price, duration_minutes)
      `)
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Deletar agendamento
app.delete('/schedules/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('schedules')
      .delete()
      .eq('id', id)
      .eq('user_id', req.user.id);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json({ message: 'Agendamento deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// PAGAMENTOS
// ==========================================

// Listar pagamentos do usuário
app.get('/payments', authenticateUser, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('payments')
      .select(`
        *,
        schedules (
          id,
          scheduled_at,
          clients (name),
          services (name)
        )
      `)
      .eq('user_id', req.user.id)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Criar pagamento
app.post('/payments', authenticateUser, async (req, res) => {
  try {
    const { schedule_id, amount, currency, payment_method, transaction_id } = req.body;

    const { data, error } = await supabase
      .from('payments')
      .insert({
        user_id: req.user.id,
        schedule_id,
        amount,
        currency: currency || 'MZN',
        payment_method,
        transaction_id
      })
      .select(`
        *,
        schedules (
          id,
          scheduled_at,
          clients (name),
          services (name)
        )
      `)
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Atualizar status do pagamento
app.put('/payments/:id/status', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const { data, error } = await supabase
      .from('payments')
      .update({ status })
      .eq('id', id)
      .eq('user_id', req.user.id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// PLANOS E SUBSCRIÇÕES
// ==========================================

// Listar planos disponíveis
app.get('/plans', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('plans')
      .select('*')
      .eq('active', true)
      .order('price', { ascending: true });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Listar subscrições do usuário
app.get('/subscriptions', authenticateUser, async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('subscriptions')
      .select(`
        *,
        plans (name, price, interval, features)
      `)
      .eq('user_id', req.user.id)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Criar subscrição
app.post('/subscriptions', authenticateUser, async (req, res) => {
  try {
    const { plan_id } = req.body;

    // Verificar se já existe uma subscrição ativa
    const { data: existingSub } = await supabase
      .from('subscriptions')
      .select('id')
      .eq('user_id', req.user.id)
      .eq('status', 'active')
      .single();

    if (existingSub) {
      return res.status(400).json({ error: 'Já existe uma subscrição ativa' });
    }

    // Obter detalhes do plano
    const { data: plan, error: planError } = await supabase
      .from('plans')
      .select('*')
      .eq('id', plan_id)
      .single();

    if (planError || !plan) {
      return res.status(400).json({ error: 'Plano não encontrado' });
    }

    // Calcular período
    const now = new Date();
    const periodEnd = new Date(now);
    if (plan.interval === 'month') {
      periodEnd.setMonth(now.getMonth() + 1);
    } else {
      periodEnd.setFullYear(now.getFullYear() + 1);
    }

    const { data, error } = await supabase
      .from('subscriptions')
      .insert({
        user_id: req.user.id,
        plan_id,
        current_period_start: now.toISOString(),
        current_period_end: periodEnd.toISOString()
      })
      .select(`
        *,
        plans (name, price, interval, features)
      `)
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.status(201).json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Cancelar subscrição
app.put('/subscriptions/:id/cancel', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;

    const { data, error } = await supabase
      .from('subscriptions')
      .update({
        cancel_at_period_end: true
      })
      .eq('id', id)
      .eq('user_id', req.user.id)
      .select(`
        *,
        plans (name, price, interval, features)
      `)
      .single();

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// ==========================================
// DASHBOARD / ESTATÍSTICAS
// ==========================================

// Estatísticas do usuário
app.get('/dashboard/stats', authenticateUser, async (req, res) => {
  try {
    // Contar clientes
    const { count: clientsCount } = await supabase
      .from('clients')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', req.user.id);

    // Contar serviços
    const { count: servicesCount } = await supabase
      .from('services')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', req.user.id);

    // Contar agendamentos
    const { count: schedulesCount } = await supabase
      .from('schedules')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', req.user.id);

    // Somar pagamentos
    const { data: payments } = await supabase
      .from('payments')
      .select('amount')
      .eq('user_id', req.user.id)
      .eq('status', 'paid');

    const totalRevenue = payments?.reduce((sum, payment) => sum + parseFloat(payment.amount), 0) || 0;

    // Agendamentos hoje
    const today = new Date().toISOString().split('T')[0];
    const { count: todaySchedules } = await supabase
      .from('schedules')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', req.user.id)
      .gte('scheduled_at', `${today}T00:00:00.000Z`)
      .lt('scheduled_at', `${today}T23:59:59.999Z`);

    res.json({
      clients: clientsCount || 0,
      services: servicesCount || 0,
      schedules: schedulesCount || 0,
      todaySchedules: todaySchedules || 0,
      totalRevenue
    });
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 API rodando em http://localhost:${PORT}`);
  console.log(`📱 Pronto para receber requisições do mobile!`);
});
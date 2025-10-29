# Refresh API

API REST para o aplicativo Refresh - Sistema de Gestão de Serviços.

## 🚀 Como executar

```bash
cd api
npm install
npm start
# ou para desenvolvimento
npm run dev
```

A API estará disponível em `http://localhost:3000`

## 📱 Endpoints

### Autenticação

#### POST `/auth/register`
Registra um novo usuário.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "full_name": "João Silva",
  "phone": "+258 84 123 4567"
}
```

#### POST `/auth/login`
Faz login do usuário.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### POST `/auth/logout`
Faz logout (requer autenticação).

#### GET `/auth/me`
Retorna informações do usuário autenticado (requer autenticação).

### Perfis

#### PUT `/profile`
Atualiza o perfil do usuário (requer autenticação).

**Body:**
```json
{
  "full_name": "João Silva Atualizado",
  "phone": "+258 84 123 4567",
  "address": "Maputo, Moçambique"
}
```

### Clientes

#### GET `/clients`
Lista todos os clientes do usuário (requer autenticação).

#### POST `/clients`
Cria um novo cliente (requer autenticação).

**Body:**
```json
{
  "name": "Maria Santos",
  "email": "maria@example.com",
  "phone": "+258 84 987 6543",
  "address": "Maputo",
  "notes": "Cliente preferencial"
}
```

#### PUT `/clients/:id`
Atualiza um cliente (requer autenticação).

#### DELETE `/clients/:id`
Deleta um cliente (requer autenticação).

### Serviços

#### GET `/services`
Lista todos os serviços do usuário (requer autenticação).

#### POST `/services`
Cria um novo serviço (requer autenticação).

**Body:**
```json
{
  "name": "Corte de Cabelo Masculino",
  "description": "Corte completo com lavagem",
  "price": 25.00,
  "duration_minutes": 60,
  "category": "Cabelo"
}
```

#### PUT `/services/:id`
Atualiza um serviço (requer autenticação).

#### DELETE `/services/:id`
Deleta um serviço (requer autenticação).

### Agendamentos

#### GET `/schedules`
Lista todos os agendamentos do usuário (requer autenticação).

#### POST `/schedules`
Cria um novo agendamento (requer autenticação).

**Body:**
```json
{
  "client_id": "uuid-do-cliente",
  "service_id": "uuid-do-serviço",
  "scheduled_at": "2025-10-30T14:00:00Z",
  "notes": "Cliente prefere horário da tarde"
}
```

#### PUT `/schedules/:id`
Atualiza um agendamento (requer autenticação).

#### DELETE `/schedules/:id`
Deleta um agendamento (requer autenticação).

### Pagamentos

#### GET `/payments`
Lista todos os pagamentos do usuário (requer autenticação).

#### POST `/payments`
Cria um novo pagamento (requer autenticação).

**Body:**
```json
{
  "schedule_id": "uuid-do-agendamento",
  "amount": 25.00,
  "currency": "MZN",
  "payment_method": "Dinheiro",
  "transaction_id": "TXN123456"
}
```

#### PUT `/payments/:id/status`
Atualiza o status de um pagamento (requer autenticação).

**Body:**
```json
{
  "status": "paid"
}
```

### Planos e Subscrições

#### GET `/plans`
Lista todos os planos disponíveis (público).

#### GET `/subscriptions`
Lista subscrições do usuário (requer autenticação).

#### POST `/subscriptions`
Cria uma nova subscrição (requer autenticação).

**Body:**
```json
{
  "plan_id": "uuid-do-plano"
}
```

#### PUT `/subscriptions/:id/cancel`
Cancela uma subscrição (requer autenticação).

### Dashboard

#### GET `/dashboard/stats`
Retorna estatísticas do usuário (requer autenticação).

**Resposta:**
```json
{
  "clients": 15,
  "services": 8,
  "schedules": 45,
  "todaySchedules": 3,
  "totalRevenue": 1250.00
}
```

## 🔐 Autenticação

Todos os endpoints marcados como "(requer autenticação)" precisam do header:

```
Authorization: Bearer <token>
```

O token é obtido através do login (`/auth/login`).

## 📊 Status Codes

- `200` - Sucesso
- `201` - Criado
- `400` - Erro na requisição
- `401` - Não autorizado
- `500` - Erro interno do servidor

## 🗄️ Base de Dados

A API utiliza Supabase como base de dados com as seguintes tabelas:

- `profiles` - Perfis de usuários
- `clients` - Clientes
- `services` - Serviços
- `schedules` - Agendamentos
- `payments` - Pagamentos
- `plans` - Planos de subscrição
- `subscriptions` - Subscrições

## 🔧 Desenvolvimento

Para desenvolvimento, use:

```bash
npm run dev
```

Isso iniciará o servidor com nodemon para recarregamento automático.
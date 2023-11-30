# Pousadaria APP

## Conteúdo

1. [Versões](#versões)

2. [Documentação API (v1)](#documentação-api)
    - [Listagem de pousadas](#listagem-de-pousadas)
    - [Detalhes de uma pousada](#detalhes-de-uma-pousada)
    - [Listagem de quartos](#listagem-de-quartos)
    - [Disponibilidade de reserva](#disponibilidade-de-reserva)
    - [Respostas para erros genéricos](#respostas-para-erros-genéricos)

## Versões

- Ruby: 3.2.2
  
- Rails: 7.1.1

## Documentação API

### Listagem de pousadas

Lista todas as pousadas cadastradas que estejam ativas.

Aceita parâmetro para busca por nome.

```http
GET /api/v1/guesthouses/?query=
```

| Parâmetro | Tipo | Obrigatório? | Descrição |
| :--- | :--- | :--- | :--- |
| `query` | `String` | Não | Termo para busca. |

#### Respostas

**200 OK**:

```json
[
  {
    "id": 1,
    "trading_name": "Pousada do Litoral"
  },
  {
    "id": 3,
    "trading_name": "Pousada do Mar"
  }
]
```

ou

```json
{
  []
}
```

caso não haja pousadas a serem exibidas.

---

### Detalhes de uma pousada

Lista detalhes de uma pousada que esteja ativa.

```http
GET /api/v1/guesthouses/:id
```

#### Respostas

**200 OK**:

```json
{
  "id": 1,
  "trading_name": "Pousada do Litoral",
  "description": "Pousada localizada no litoral sul.",
  "allow_pets": true,
  "usage_policy": "Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h",
  "check_in": "11:00",
  "check_out": "14:00",
  "payment_methods": "Dinheiro, Pix e Cartão de Crédito",
  "address": {
    "street_name": "Rua das Pousadas",
    "street_number": "44",
    "complement": "",
    "district": "Jd. Maresia",
    "city": "Santos",
    "state": "SP",
    "postal_code": "11010-010"
  },
  "contact": {
    "phone": "11912344321",
    "email": "pousada@contato.com"
  }
}
```

**404 NOT_FOUND** (Pousada inativa):

```json
{
  "message": "Pousada está inativa."
}
```

---

### Listagem de quartos

Lista todos os quartos ativos de uma pousada também ativa.

```http
GET /api/v1/guesthouses/:guesthouse_id/rooms
```

#### Respostas

**200 OK**:

```json
[
  {
    "id": 1,
    "name": "Suíte Master",
    "description": "Suíte espaçosa com bela vista para o mar.",
    "area": "30",
    "daily_rate": "99.99",
    "guesthouse_id": 3
  },
  {
    "id": 3,
    "name": "Quarto Simples",
    "description": "Quarto aconchegante.",
    "area": "15",
    "daily_rate": "49.99",
    "guesthouse_id": 3
  }
]
```

ou

```json
{
  []
}
```

caso não haja quartos a serem exibidos.

**404 NOT_FOUND** (Pousada inativa):

```json
{
  "message": "Pousada está inativa."
}
```

---

### Disponibilidade de reserva 

Verifica se já existe uma reserva pendente ou em andamento no período especificado.

Recebe parâmetros para consultar e validar a reserva.

```http
GET /api/v1/rooms/:room_id/validate-booking/?start_date=&finish_date=&guests_number=
```

| Parâmetro | Tipo | Obrigatório? | Descrição |
| :--- | :--- | :--- | :--- |
| `start_date` | `Date` | **Sim** | Data inicial da estadia. |
| `finish_date` | `Date` | **Sim** | Data final da estadia. |
| `guests_number` | `Integer` | **Sim** | Quantidade de hóspedes. |

#### Respostas

**200 OK**:

```json
{
  "total_price": "500.0"
}
```

**400 BAD_REQUEST**:

```json
{
  "message": "Parâmetros inválidos.",
  "errors": [
    "Data Inicial deve ser futura",
    "Data Final não pode ficar em branco",
    "Quantidade de Hóspedes deve respeitar capacidade máxima do quarto"
  ]
}
```

**404 NOT_FOUND** (Quarto inativo):

```json
{
  "message": "Quarto está inativo."
}
```

**409 CONFLICT**:

```json
{
  "message": "Parâmetros inválidos",
  "errors": [
    "Já existe uma reserva no período especificado"
  ]
}
```

---

### Respostas para erros genéricos

**404 NOT_FOUND**:

```json
{
  "message": "Recurso não encontrado."
}
```

**500 INTERNAL_SERVER_ERROR**:

```json
{
  "message": "Erro interno de servidor."
}
```
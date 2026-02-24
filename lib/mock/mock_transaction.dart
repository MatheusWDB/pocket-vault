import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/models/tag.dart';

final now = DateTime.now();

final List<Transaction> mockTransactions = [
  // ===== HOJE =====
  Transaction(
    id: 1,
    title: 'Café',
    amount: -8.50,
    date: now,
    categoryId: 2,
    isRecurring: false,
    tags: [Tag(id: 1, name: 'Alimentação')],
    createdAt: now,
  ),

  Transaction(
    id: 2,
    title: 'Salário',
    amount: 3500.00,
    date: now,
    categoryId: 1,
    isRecurring: true,
    tags: [Tag(id: 2, name: 'Renda')],
    createdAt: now,
  ),

  // ===== ONTEM =====
  Transaction(
    id: 3,
    title: 'Uber',
    amount: -23.40,
    date: now.subtract(const Duration(days: 1)),
    categoryId: 3,
    isRecurring: false,
    tags: [Tag(id: 3, name: 'Transporte')],
  ),

  Transaction(
    id: 4,
    title: 'Mercado',
    amount: -185.90,
    date: now.subtract(const Duration(days: 1)),
    categoryId: 2,
    isRecurring: false,
    tags: [Tag(id: 1, name: 'Alimentação')],
  ),

  // ===== ESTE MÊS =====
  Transaction(
    id: 5,
    title: 'Cinema',
    amount: -32.00,
    date: now.subtract(const Duration(days: 3)),
    categoryId: 4,
    isRecurring: false,
    tags: [Tag(id: 4, name: 'Entretenimento')],
  ),

  Transaction(
    id: 6,
    title: 'Restaurante',
    amount: -76.50,
    date: now.subtract(const Duration(days: 7)),
    categoryId: 2,
    isRecurring: false,
  ),

  Transaction(
    id: 7,
    title: 'Internet',
    amount: -99.90,
    date: now.subtract(const Duration(days: 10)),
    categoryId: 5,
    isRecurring: true,
    tags: [Tag(id: 5, name: 'Serviços')],
  ),

  Transaction(
    id: 8,
    title: 'Venda OLX',
    amount: 200.00,
    date: now.subtract(const Duration(days: 12)),
    categoryId: 6,
    isRecurring: false,
    tags: [Tag(id: 6, name: 'Extra')],
  ),

  // ===== ESTE ANO (meses anteriores) =====
  Transaction(
    id: 9,
    title: 'Notebook',
    amount: -4200.00,
    date: DateTime(now.year, now.month - 1, 15),
    categoryId: 7,
    isRecurring: false,
  ),

  Transaction(
    id: 10,
    title: 'Freelance',
    amount: 1200.00,
    date: DateTime(now.year, now.month - 2, 10),
    categoryId: 1,
    isRecurring: false,
  ),

  Transaction(
    id: 11,
    title: 'Academia',
    amount: -89.90,
    date: DateTime(now.year, now.month - 3, 5),
    categoryId: 8,
    isRecurring: true,
  ),

  Transaction(
    id: 12,
    title: 'Presente',
    amount: -150.00,
    date: DateTime(now.year, 1, 12),
    categoryId: 9,
    isRecurring: false,
  ),

  // ===== ANO PASSADO =====
  Transaction(
    id: 13,
    title: 'Viagem',
    amount: -2500.00,
    date: DateTime(now.year - 1, 12, 20),
    categoryId: 10,
    isRecurring: false,
  ),

  Transaction(
    id: 14,
    title: '13º Salário',
    amount: 4000.00,
    date: DateTime(now.year - 1, 12, 15),
    categoryId: 1,
    isRecurring: false,
  ),

  Transaction(
    id: 15,
    title: 'Celular',
    amount: -1800.00,
    date: DateTime(now.year - 1, 8, 10),
    categoryId: 7,
    isRecurring: false,
  ),

  // ===== DOIS ANOS ATRÁS =====
  Transaction(
    id: 16,
    title: 'Curso',
    amount: -600.00,
    date: DateTime(now.year - 2, 5, 18),
    categoryId: 11,
    isRecurring: false,
  ),

  Transaction(
    id: 17,
    title: 'Projeto Freelance',
    amount: 950.00,
    date: DateTime(now.year - 2, 3, 22),
    categoryId: 1,
    isRecurring: false,
  ),

  // ===== TRÊS ANOS ATRÁS =====
  Transaction(
    id: 18,
    title: 'Compra antiga',
    amount: -120.00,
    date: DateTime(now.year - 3, 11, 2),
    categoryId: 2,
    isRecurring: false,
  ),
];

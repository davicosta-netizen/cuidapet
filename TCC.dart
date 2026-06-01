import 'dart:io';

List<Map<String, dynamic>> carrinho = [];
int totalVendas = 0;
double valorTotalDia = 0.0;

void main() {
  bool rodando = true;

  while (rodando) {
    exibirBoasVindas();
    String? nome = lerNome();

    if (nome == "cuidapetrestrito") {
      areaRestrita();
      continue;
    }

    atenderCliente(nome);

    rodando = desejaEncerrarDia();
  }

  exibirResumoFinal();
}

void exibirBoasVindas() {
  print("\nBem vindo ao autoatendimento do Cuidapet");
}

String? lerNome() {
  stdout.write("Digite seu nome: ");
  return stdin.readLineSync();
}

void atenderCliente(String? nome) {
  bool noSistema = true;

  while (noSistema) {
    exibirMenuPrincipal();
    String? opcao = lerOpcao();

    switch (opcao) {
      case "1":
        mostrarPromocoes();
        break;
      case "2":
        mostrarServicos();
        break;
      case "3":
        listarCarrinho();
        break;
      case "4":
        finalizarCompra(nome);
        break;
      case "0":
        print("\nVolte sempre, $nome!");
        noSistema = false;
        break;
      default:
        print("Opção inválida! Tente novamente.");
    }
  }
}

void exibirMenuPrincipal() {
  print("\n=== MENU PRINCIPAL ===");
  print("1 - Ver promoções");
  print("2 - Solicitar serviço");
  print("3 - Listar carrinho de compra");
  print("4 - Finalizar carrinho de compra");
  print("0 - Sair");
}

String? lerOpcao() {
  stdout.write("Digite sua opção desejada: ");
  return stdin.readLineSync();
}

void mostrarPromocoes() {
  bool voltar = false;

  while (!voltar) {
    exibirListaProdutos();
    String? opcao = lerOpcaoProduto();

    if (opcao == "0") {
      voltar = true;
    } else if (opcao == "8") {
      adicionarItemPorCodigo();
    } else if (ehCodigoProdutoValido(opcao)) {
      print("Use a opção 8 para adicionar ao carrinho com o código do produto.");
    } else {
      print("Opção inválida!");
    }
  }
}

void exibirListaProdutos() {
  print("\n=== PROMOÇÕES ===");
  print("101 - Ração Royal Canin Indoor Para Cães Adultos De Porte Mini De Ambientes Internos 7,5kg - R\$ 290,00");
  print("102 - Ração Royal Canin Sterilised para Gatos Adultos Castrados - R\$ 492,00");
  print("103 - Bifinho Keldog para Cães Porte Pequeno Sabor Carne e Cereais - R\$ 23,92");
  print("104 - Fraldas Descartáveis Super Secão para Cães Machos com 12 Unidades - R\$ 38,61");
  print("8 - Adicionar ao carrinho de compras");
  print("0 - Voltar");
}

String? lerOpcaoProduto() {
  stdout.write("Digite sua opção: ");
  return stdin.readLineSync();
}

bool ehCodigoProdutoValido(String? codigo) {
  return codigo == "101" || codigo == "102" || codigo == "103" || codigo == "104";
}

void mostrarServicos() {
  bool voltar = false;

  while (!voltar) {
    exibirListaServicos();
    String? opcao = lerOpcaoServico();

    if (opcao == "0") {
      voltar = true;
    } else if (opcao == "8") {
      adicionarItemPorCodigo();
    } else if (ehCodigoServicoValido(opcao)) {
      print("Use a opção 8 para adicionar ao carrinho com o código do serviço.");
    } else {
      print("Opção inválida!");
    }
  }
}

void exibirListaServicos() {
  print("\n=== SERVIÇOS ===");
  print("201 - Banho e tosa - R\$ 55,99");
  print("202 - Tosa higiênica - R\$ 12,99");
  print("203 - Hidratação dos pelos - R\$ 20,99");
  print("8 - Adicionar ao carrinho de compras");
  print("0 - Voltar");
}

String? lerOpcaoServico() {
  stdout.write("Digite sua opção: ");
  return stdin.readLineSync();
}

bool ehCodigoServicoValido(String? codigo) {
  return codigo == "201" || codigo == "202" || codigo == "203";
}

void adicionarItemPorCodigo() {
  stdout.write("Digite o código: ");
  String? codigo = stdin.readLineSync();

  if (carrinho.length >= 3) {
    print("\nSeu carrinho de compras já está cheio. Acesso restrito!");
    return;
  }

  Map<String, dynamic>? item = buscarItemPorCodigo(codigo);

  if (item == null) {
    print("Código inválido!");
    return;
  }

  carrinho.add(item);
  print("Item adicionado ao carrinho!");
  print("Itens no carrinho: ${carrinho.length}/3");
}

Map<String, dynamic>? buscarItemPorCodigo(String? codigo) {
  if (codigo == "101") {
    return {"nome": "Ração Royal Canin Indoor 7,5kg", "valor": 290.00};
  } else if (codigo == "102") {
    return {"nome": "Ração Royal Canin Sterilised", "valor": 492.00};
  } else if (codigo == "103") {
    return {"nome": "Bifinho Keldog", "valor": 23.92};
  } else if (codigo == "104") {
    return {"nome": "Fraldas Descartáveis Super Secão", "valor": 38.61};
  } else if (codigo == "201") {
    return {"nome": "Banho e tosa", "valor": 55.99};
  } else if (codigo == "202") {
    return {"nome": "Tosa higiênica", "valor": 12.99};
  } else if (codigo == "203") {
    return {"nome": "Hidratação dos pelos", "valor": 20.99};
  }
  return null;
}

void listarCarrinho() {
  if (carrinho.isEmpty) {
    print("\nCarrinho vazio!");
    return;
  }

  print("\n=== CARRINHO DE COMPRAS ===");
  double total = 0.0;

  for (int i = 0; i < carrinho.length; i++) {
    var item = carrinho[i];
    print("${i + 1} - ${item["nome"]} - R\$ ${item["valor"].toStringAsFixed(2)}");
    total += item["valor"];
  }

  print("Total: R\$ ${total.toStringAsFixed(2)}");
}

void finalizarCompra(String? nomeCliente) {
  if (carrinho.isEmpty) {
    print("\nSeu carrinho está vazio! Adicione itens antes de finalizar.");
    return;
  }

  double total = calcularTotalCarrinho();
  print("\nTotal do carrinho: R\$ ${total.toStringAsFixed(2)}");

  String? pagamento = lerFormaPagamento();
  double valorFinal = aplicarDesconto(total, pagamento);

  print("Valor final a pagar: R\$ ${valorFinal.toStringAsFixed(2)}");

  totalVendas++;
  valorTotalDia += valorFinal;

  print("\nCompra finalizada com sucesso! Obrigado pela preferência, $nomeCliente.");
  carrinho.clear();
}

double calcularTotalCarrinho() {
  double total = 0.0;
  for (var item in carrinho) {
    total += item["valor"];
  }
  return total;
}

String? lerFormaPagamento() {
  stdout.write("Forma de pagamento (dinheiro/cartão): ");
  return stdin.readLineSync()?.toLowerCase();
}

double aplicarDesconto(double total, String? pagamento) {
  if (pagamento == "dinheiro") {
    print("Desconto de 10% aplicado!");
    return total * 0.9;
  }
  return total;
}

bool desejaEncerrarDia() {
  stdout.write("\nDeseja encerrar o atendimento do dia? (s/n): ");
  String? resposta = stdin.readLineSync()?.toLowerCase();
  return resposta == "s";
}

void exibirResumoFinal() {
  print("\n=====================================");
  print("FIM DO EXPEDIENTE");
  print("Quantidade de vendas do dia: $totalVendas");
  print("Valor total das vendas: R\$ ${valorTotalDia.toStringAsFixed(2)}");
  print("=====================================");
}

void areaRestrita() {
  print("\n=== ÁREA RESTRITA - FUNCIONÁRIOS ===");

  String? nomeCliente = lerNomeCliente();
  double? valorGasto = lerValorGasto();

  if (valorGasto == null) {
    print("Valor inválido!");
    return;
  }

  String? pagamento = lerPagamentoFuncionario();
  double valorFinal = calcularValorFinalFuncionario(valorGasto, pagamento);

  exibirResumoFuncionario(nomeCliente, valorGasto, valorFinal);
}

String? lerNomeCliente() {
  stdout.write("Nome do cliente: ");
  return stdin.readLineSync();
}

double? lerValorGasto() {
  stdout.write("Valor gasto na loja: R\$ ");
  String? input = stdin.readLineSync();
  return double.tryParse(input ?? "");
}

String? lerPagamentoFuncionario() {
  stdout.write("Forma de pagamento (D - dinheiro / C - cartão): ");
  return stdin.readLineSync()?.toUpperCase();
}

double calcularValorFinalFuncionario(double valorGasto, String? pagamento) {
  if (pagamento == "D") {
    print("Desconto de 10% aplicado!");
    return valorGasto * 0.9;
  }
  return valorGasto;
}

void exibirResumoFuncionario(String? nome, double valorOriginal, double valorFinal) {
  print("\nCliente: $nome");
  print("Valor original: R\$ ${valorOriginal.toStringAsFixed(2)}");
  print("Valor final a pagar: R\$ ${valorFinal.toStringAsFixed(2)}");
}
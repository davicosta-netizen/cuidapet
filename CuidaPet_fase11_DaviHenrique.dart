import 'dart:io';

abstract class Pagamento {
  double calcularValor(double valor);
}

class PagamentoDinheiro extends Pagamento {
  @override
  double calcularValor(double valor) => valor * 0.9;
}

class PagamentoCartao extends Pagamento {
  @override
  double calcularValor(double valor) => valor;
}

class ProdutoBase {
  int codigo;
  String nome;
  double preco;

  ProdutoBase(this.codigo, this.nome, this.preco);

  @override
  String toString() => "$nome - R\$ ${preco.toStringAsFixed(2)}";
}

class Produto extends ProdutoBase {
  Produto(super.codigo, super.nome, super.preco);
}

class Servico extends ProdutoBase {
  Servico(super.codigo, super.nome, super.preco);
}

class Carrinho {
  final List<ProdutoBase> _itens = [];

  void adicionarItem(ProdutoBase item) {
    if (_itens.length >= 3) {
      print("\nCarrinho cheio.");
      return;
    }

    _itens.add(item);
    print("${item.nome} adicionado ao carrinho.");
  }

  void listarItens() {
    print("\n--- CARRINHO DE COMPRAS ---");

    if (_itens.isEmpty) {
      print("Carrinho vazio.");
      return;
    }

    for (var item in _itens) {
      print(item);
    }
  }

  double calcularTotal() {
    double total = 0;

    for (var item in _itens) {
      total += item.preco;
    }

    return total;
  }

  void limpar() {
    _itens.clear();
  }
}

class Venda {
  static int _totalVendas = 0;
  static double _valorTotalVendas = 0;

  static int get totalVendas => _totalVendas;
  static double get valorTotalVendas => _valorTotalVendas;

  static void registrarVenda(double valor) {
    _totalVendas++;
    _valorTotalVendas += valor;
  }
}

class CuidaPet {
  final List<Produto> promocoes = [
    Produto(101, "Ração Royal Canin", 290.00),
    Produto(102, "Ração Royal Canin para Gatos", 492.00),
    Produto(103, "Bifinho Keldog", 23.92),
    Produto(104, "Fraldas Descartáveis", 38.61),
  ];

  final List<Servico> servicos = [
    Servico(201, "Banho e tosa", 55.99),
    Servico(202, "Tosa higiênica", 12.99),
    Servico(203, "Hidratação dos pelos", 20.99),
  ];

  ProdutoBase? buscarItem(int codigo) {
    for (var item in [...promocoes, ...servicos]) {
      if (item.codigo == codigo) return item;
    }
    return null;
  }

  int menuPrincipal() {
    print("\n------- MENU -------");
    print("1 - Ver promoções");
    print("2 - Solicitar serviço");
    print("3 - Listar carrinho de compra");
    print("4 - Finalizar carrinho de compra");
    print("0 - Sair");

    return int.parse(stdin.readLineSync()!);
  }

  void menuPromocoes(Carrinho carrinho) {
    while (true) {
      print("\n--- PROMOÇÕES ---");
      for (var p in promocoes) {
        print("${p.codigo} - ${p.nome} - R\$ ${p.preco}");
      }
      print("8 - Adicionar ao carrinho");
      print("0 - Voltar");

      int op = int.parse(stdin.readLineSync()!);

      if (op == 0) break;

      if (op == 8) {
        print("Digite o código do produto:");
        int codigo = int.parse(stdin.readLineSync()!);

        var item = buscarItem(codigo);

        if (item != null) {
          carrinho.adicionarItem(item);
        } else {
          print("Código inválido.");
        }
      }
    }
  }

  void menuServicos(Carrinho carrinho) {
    while (true) {
      print("\n--- SERVIÇOS ---");
      for (var s in servicos) {
        print("${s.codigo} - ${s.nome} - R\$ ${s.preco}");
      }
      print("8 - Adicionar ao carrinho");
      print("0 - Voltar");

      int op = int.parse(stdin.readLineSync()!);

      if (op == 0) break;

      if (op == 8) {
        print("Digite o código do serviço:");
        int codigo = int.parse(stdin.readLineSync()!);

        var item = buscarItem(codigo);

        if (item != null) {
          carrinho.adicionarItem(item);
        } else {
          print("Código inválido.");
        }
      }
    }
  }

  void finalizarCompra(Carrinho carrinho) {
    double total = carrinho.calcularTotal();

    print("Forma de pagamento (D - dinheiro / C - cartão):");
    String forma = stdin.readLineSync()!;

    Pagamento pagamento;

    if (forma.toUpperCase() == "D") {
      pagamento = PagamentoDinheiro();
    } else {
      pagamento = PagamentoCartao();
    }

    double valorFinal = pagamento.calcularValor(total);

    print("Valor final a pagar: R\$ ${valorFinal.toStringAsFixed(2)}");

    Venda.registrarVenda(valorFinal);
    carrinho.limpar();
  }

  void areaRestrita() {
    print("\n--- ÁREA RESTRITA ---");

    print("Digite o nome do cliente:");
    String cliente = stdin.readLineSync()!;

    print("Digite o valor gasto:");
    double valor = double.parse(stdin.readLineSync()!);

    print("Forma de pagamento (D - dinheiro / C - cartão):");
    String forma = stdin.readLineSync()!;

    Pagamento pagamento;

    if (forma.toUpperCase() == "D") {
      pagamento = PagamentoDinheiro();
    } else {
      pagamento = PagamentoCartao();
    }

    double valorFinal = pagamento.calcularValor(valor);

    print("\nCliente: $cliente");
    print("Valor final: R\$ ${valorFinal.toStringAsFixed(2)}");

    Venda.registrarVenda(valorFinal);
  }

  void encerrarSistema() {
    print("\nEncerrando sistema...");
    print("Quantidade de vendas: ${Venda.totalVendas}");
    print("Valor total das vendas: R\$ ${Venda.valorTotalVendas.toStringAsFixed(2)}");
  }
}

void main() {
  CuidaPet sistema = CuidaPet();

  while (true) {
    print("\nBem vindo ao autoatendimento do CuidaPet");
    print("Digite seu nome:");

    String nome = stdin.readLineSync()!;

    if (nome == "cuidapetrestrito") {
      sistema.areaRestrita();
      continue;
    }

    Carrinho carrinho = Carrinho();

    while (true) {
      int opcao = sistema.menuPrincipal();

      if (opcao == 0) {
        sistema.encerrarSistema();
        return;
      }

      switch (opcao) {
        case 1:
          sistema.menuPromocoes(carrinho);
          break;
        case 2:
          sistema.menuServicos(carrinho);
          break;
        case 3:
          carrinho.listarItens();
          break;
        case 4:
          sistema.finalizarCompra(carrinho);
          break;
        default:
          print("Opção inválida.");
      }
    }
  }
}

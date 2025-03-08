double calculateTax(List<dynamic> valores, int qtdAdultos, int qtdCriancas, int qtdBebes) {
  double total = 0.0;

  if (valores.isEmpty) {
    return total;
  }

  for (var valor in valores) {
    double precoAdulto = valor["Adulto"] ?? 0.0; 
    double precoCrianca = valor["Crianca"] ?? 0.0; 
    double precoBebe = valor["Bebe"] ?? 0.0; 
    double taxaEmbarque = valor["TaxaEmbarque"] ?? 0.0; 

    total = (precoAdulto * qtdAdultos) + (precoCrianca * qtdCriancas) + (precoBebe * qtdBebes) + (taxaEmbarque * (qtdAdultos + qtdCriancas + qtdBebes));
  }

  return total;
}

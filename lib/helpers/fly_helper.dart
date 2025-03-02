List<String> generateAirportCombinations() {
  List<String> combinations = [];
  for (int i = 65; i <= 83; i++) { 
    for (int j = 65; j <= 90; j++) { 
      for (int k = 65; k <= 90; k++) {
        String combination = String.fromCharCode(i) +
                             String.fromCharCode(j) +
                             String.fromCharCode(k);
        combinations.add(combination);
        if (combination == "SAO") return combinations;
      }
    }
  }
  
  return combinations;
}

String formatDate(String date) {
  List<String> parts = date.split('-');
  if (parts.length == 3) {
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
  return date;
}


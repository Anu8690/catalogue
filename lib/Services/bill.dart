void bill(List<Map<String, dynamic>> M, Map<String, int>? quantity) {
  String s = "|";
  int maxNameLength = 0;
  M.map((product) {
    if (maxNameLength < product['name'].length)
      maxNameLength = product['name'].length;
  });
  s += "  ID|";
  for (int i = 0; i < maxNameLength - 4; i++) s += " ";
  s += "Name|Price| QTY|Total|\n";
  M.map((product) {
    s += '|${product['productId']}|';
    for (int i = 0; i < maxNameLength - product['name'].length; i++) s += ' ';
    s += '${product['name']}|';
    for (int i = 0; i < 5 - product['price'].length; i++) s += ' ';
    s += '${product['price']}|';
    String qty = quantity![product['productId']] as String;
    for (int i = 0; i < 4 - qty.length; i++) s += ' ';
    s += '$qty|';
    int total = (product['price'] as int) * (qty as int);
    String totalString = total as String;
    for (int i = 0; i < 5 - totalString.length; i++) s += ' ';
    s += '$totalString|\n';
  });
  print(s);
}

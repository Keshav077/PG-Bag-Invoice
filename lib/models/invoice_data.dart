class InvoiceData {
  // Customer
  String customerName = '';

  // Section 1
  double grams = 0;
  double width = 0;
  double length = 0;
  double yarn = 1;

  double get meterWeight => grams * width;
  double get perInchWeight => meterWeight / 39.37;
  double get bagWeight => perInchWeight * length;
  double get totalBagWeight => bagWeight + yarn;

  // Section 2
  double fabricRate = 0;
  double cuttingCharges = 0.2;
  double stitchingCharges = 0.2;
  double misc = 0.2;
  double printing = 0.75;
  double lyner = 0;
  double gazzette = 0.3;
  double transport = 0.1;
  double marginPercentage = 0;

  double get fabricCost => totalBagWeight * fabricRate / 1000;
  double get bagCost =>
      fabricCost +
      cuttingCharges +
      stitchingCharges +
      misc +
      printing +
      lyner +
      gazzette +
      transport;
  double get marginAmount => bagCost * marginPercentage / 100;
  double get finalBagCost => bagCost + marginAmount;
}

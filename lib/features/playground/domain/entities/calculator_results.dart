import 'package:equatable/equatable.dart';

class EmiResultEntity extends Equatable {
  final double principal;
  final double monthlyEmi;
  final double totalInterest;
  final double totalPayable;

  const EmiResultEntity({
    required this.principal,
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalPayable,
  });

  /// Interest as a share of everything repaid — drives the donut split.
  double get interestShare =>
      totalPayable == 0 ? 0 : totalInterest / totalPayable;

  @override
  List<Object> get props =>
      [principal, monthlyEmi, totalInterest, totalPayable];
}

class SipResultEntity extends Equatable {
  final double investedAmount;
  final double estimatedReturns;
  final double totalValue;

  const SipResultEntity({
    required this.investedAmount,
    required this.estimatedReturns,
    required this.totalValue,
  });

  double get returnsShare =>
      totalValue == 0 ? 0 : estimatedReturns / totalValue;

  @override
  List<Object> get props => [investedAmount, estimatedReturns, totalValue];
}

class SalaryBreakdownEntity extends Equatable {
  final double ctc;
  final double basic;
  final double hra;
  final double otherAllowances;
  final double employeePf;
  final double employerPf;
  final double gratuity;
  final double professionalTax;
  final double incomeTax;
  final double annualInHand;

  const SalaryBreakdownEntity({
    required this.ctc,
    required this.basic,
    required this.hra,
    required this.otherAllowances,
    required this.employeePf,
    required this.employerPf,
    required this.gratuity,
    required this.professionalTax,
    required this.incomeTax,
    required this.annualInHand,
  });

  double get monthlyInHand => annualInHand / 12;

  double get totalDeductions =>
      employeePf + professionalTax + incomeTax;

  @override
  List<Object> get props => [
    ctc,
    basic,
    hra,
    otherAllowances,
    employeePf,
    employerPf,
    gratuity,
    professionalTax,
    incomeTax,
    annualInHand,
  ];
}

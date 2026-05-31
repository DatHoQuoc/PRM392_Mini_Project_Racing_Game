/// The outcome of a finished race.
class RaceResultModel {
  /// ID of the winning car.
  final int winnerId;
  /// Map of carId → bet amount placed before the race.
  final Map<int, double> bets;
  /// Net wallet change after payouts (positive = profit, negative = loss).
  final double payoutDelta;

  const RaceResultModel({
    required this.winnerId,
    required this.bets,
    required this.payoutDelta,
  });

  @override
  String toString() =>
      'RaceResultModel(winner: $winnerId, delta: $payoutDelta)';
}
part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.displayManualMarket = false,
    this.places = const [],
    this.history = const [],
    this.typeMarket,
  });

  final bool displayManualMarket;
  final List<Prediction> places;
  final List<Prediction> history;
  final TypeMarket? typeMarket;

  SearchState copyWith({
    bool? displayManualMarket,
    List<Prediction>? places,
    List<Prediction>? history,
    TypeMarket? typeMarket,
  }) =>
      SearchState(
        displayManualMarket: displayManualMarket ?? this.displayManualMarket,
        places: places ?? this.places,
        history: history ?? this.history,
        typeMarket: typeMarket ?? this.typeMarket,
      );

  @override
  List<Object?> get props => [
        displayManualMarket,
        places,
        history,
        typeMarket,
      ];
}

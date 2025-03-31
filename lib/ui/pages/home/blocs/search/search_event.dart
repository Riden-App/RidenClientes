part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarketEvent extends SearchEvent {}

class OffActivateManualMarketEvent extends SearchEvent {}

class OnNewPlacesFounEvent extends SearchEvent {
  const OnNewPlacesFounEvent(this.places);

  final List<Prediction> places;
}

class AddToHistoryEvent extends SearchEvent {
  const AddToHistoryEvent(this.place);

  final Prediction place;
}

class UpdateTypeMarketEvent extends SearchEvent {
  const UpdateTypeMarketEvent(this.typeMarket);

  final TypeMarket typeMarket;
}

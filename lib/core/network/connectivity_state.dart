part of 'connectivity_cubit.dart';

class ConnectivityState extends Equatable {
  final bool isOnline;

  const ConnectivityState({this.isOnline = true});

  @override
  List<Object?> get props => [isOnline];
}

import 'package:flutter_bloc/flutter_bloc.dart';

enum PlaygroundTool { tally, salary, emi, sip, breathe }

/// Which tool is on screen. Small, but it is still state the widget tree
/// reads rather than owns, so it lives here instead of in a `setState`.
class PlaygroundCubit extends Cubit<PlaygroundTool> {
  PlaygroundCubit() : super(PlaygroundTool.tally);

  void select(PlaygroundTool tool) => emit(tool);
}

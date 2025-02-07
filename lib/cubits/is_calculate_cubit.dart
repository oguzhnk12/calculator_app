import 'package:flutter_bloc/flutter_bloc.dart';

class IsCalculateCubit extends Cubit<bool> {
  IsCalculateCubit() : super(false);

  void setIsCalculated(bool isCalculated) {
    emit(isCalculated);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

class IsCalculatedCubit extends Cubit<bool> {
  IsCalculatedCubit() : super(false);

  void setIsCalculated(bool isCalculated) {
    emit(isCalculated);
  }
}

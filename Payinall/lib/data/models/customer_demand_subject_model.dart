import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/customer_demand_subject_response.dart';
import 'package:payinall/domain/entities/customer_demand_subject.dart';

final class CustomerDemandSubjectModel extends CustomerDemandSubject {
  const CustomerDemandSubjectModel({required super.key, required super.value});

  factory CustomerDemandSubjectModel.fromResponse(
    CustomerDemandSubjectResponse response,
  ) {
    if (response.key == null || response.value == null) {
      throw const MappingException();
    }

    return CustomerDemandSubjectModel(
      key: response.key!,
      value: response.value!,
    );
  }
}

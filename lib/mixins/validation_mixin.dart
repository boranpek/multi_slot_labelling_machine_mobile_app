class ValidationMixin{

  String validateRunNumber(String value){
    if(int.parse(value) <= 0)
      return "Value should be greater then 0 !";
    return null;
  }

  String validateSlotNumber(String value){
    if(int.parse(value) <= 0)
      return "Value should be greater then 0 !";
    return null;
  }

  String validateProductNumber(String value){
    if(int.parse(value) <= 0)
      return "Value should be greater then 0 !";
    return null;
  }

  String validateProductDemand(String value){
    if(int.parse(value) <= 0)
      return "Demand should be greater then 0 !";
    return null;
  }
}
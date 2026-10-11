
class DataFromWebsite {
  bool isLoading;
  dynamic dataFromWeb;

  DataFromWebsite({this.isLoading = false, this.dataFromWeb = ''});

  DataFromWebsite copyWith({bool? isLoading, dynamic dataFromWeb}) {
    return DataFromWebsite(
      isLoading: isLoading ?? this.isLoading,
      dataFromWeb: dataFromWeb ?? this.dataFromWeb,
    );
  }
}